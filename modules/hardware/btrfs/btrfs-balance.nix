{
  pkgs,
  lib,
}: let
  deps = lib.attrValues {
    inherit
      (pkgs)
      btrfs-progs
      util-linux
      coreutils
      gnugrep
      gnused
      ;
  };
in
  # Periodic balance, adapted from btrfsmaintenance's btrfs-balance.sh and
  # the balance-related helpers of btrfsmaintenance-functions:
  # https://github.com/kdave/btrfsmaintenance
  #
  # Differences from upstream:
  # - config comes from the environment (set by the systemd unit)
  #   instead of sourcing /etc/sysconfig or /etc/default
  # - stdout/stderr go to the journal via the systemd unit, so the
  #   BTRFS_LOG_OUTPUT switch and systemd-cat/logger are gone
  # - flock is resolved from PATH instead of /usr/bin/flock
  #
  # Environment:
  #   BTRFS_BALANCE_MOUNTPOINTS  ":"-separated mountpoints; "auto" = all btrfs
  #   BTRFS_BALANCE_DUSAGE       usage thresholds (%) for data block groups
  #   BTRFS_BALANCE_MUSAGE       usage thresholds (%) for metadata block groups
  #   BTRFS_ALLOW_CONCURRENCY    "true" to skip the flock serialization
  pkgs.writeShellScript "btrfs-balance"
  # bash
  ''
    umask 022
    export PATH="${lib.makeBinPath deps}"
    exec 2>&1

    # function: expand_auto_mountpoint
    # parameter: path list from config variable or 'auto'
    #
    # if the parameter is 'auto', this function prints path list of all btrfs
    # mountpoints, otherwise prints the parameter unchanged
    expand_auto_mountpoint() {
      local MNTLIST="$1"

      if [ "$MNTLIST" = "auto" ]; then
        local BTRFS_DEVICES
        local DEVICE
        local MNT

        # find all mounted btrfs filesystems, print their device nodes, sort them
        # and remove identical entries
        BTRFS_DEVICES=$(findmnt --types btrfs --output "SOURCE" --nofsroot --noheading | sort | uniq)
        # find one (and only one) corresponding mountpoint for each btrfs device node
        MNTLIST=""
        for DEVICE in $BTRFS_DEVICES; do
          MNT=$(findmnt --types btrfs --first-only --noheadings --output "TARGET" --source "$DEVICE")
          if [ -n "$MNTLIST" ]; then
            MNTLIST="$MNTLIST:$MNT"
          else
            MNTLIST="$MNT"
          fi
        done
      fi
      echo -n "$MNTLIST"
    }

    # function: detect_mixed_bg
    # parameter: path to a mounted filesystem
    #
    # check if the filesystem contains mixed block groups,
    detect_mixed_bg() {
      # simple test is to read 'btrfs fi df',
      # (we could look for /sys/sfs/btrfs/UUID/allocation/mixed if we know
      # the UUID)

      btrfs filesystem df "$1" | grep -q "Data+Metadata"
    }

    # function: is_btrfs
    # parameter: path to a mounted filesystem
    #
    # check if filesystem is a btrfs
    is_btrfs() {
      local FS=$(stat -f --format=%T "$1")

      [ "$FS" = "btrfs" ] && return 0
      return 1
    }

    # function: btrfs_fsid
    # parameter: path to a mounted filesystem
    #
    # return filesystem UUID on a given path
    btrfs_fsid() {
      btrfs filesystem show "$1" | sed -n -e '/uuid:/ {s/^.*uuid: //;p }'
    }

    # function: run_task
    # parameter: command to run, expecting the mountpoint to be the last argument
    #
    # run the given command with concurrency protection unless allowed by the
    # config, use for tasks that should not run at the same time due to heavy IO
    run_task() {
      local MNT="''${@:$#}"
      local UUID=$(btrfs_fsid "$MNT")

      if test "$BTRFS_ALLOW_CONCURRENCY" = "true"; then
        "$@"
      else
        flock --verbose /run/btrfs-maintenance-running."$UUID" "$@"
      fi
    }

    BTRFS_BALANCE_MOUNTPOINTS=$(expand_auto_mountpoint "$BTRFS_BALANCE_MOUNTPOINTS")
    OIFS="$IFS"
    IFS=:
    for MM in $BTRFS_BALANCE_MOUNTPOINTS; do
      IFS="$OIFS"
      if ! is_btrfs "$MM"; then
        echo "Path $MM is not btrfs, skipping"
        continue
      fi
      echo "Before balance of $MM"
      btrfs filesystem df "$MM"
      df -H "$MM"

      if detect_mixed_bg "$MM"; then
        run_task btrfs balance start -musage=0 -dusage=0 "$MM"
        # we use the MUSAGE values for both, supposedly less aggressive
        # values, but as the data and metadata space is shared on
        # mixed-bg this does not lead to the situations we want to
        # prevent when the blockgroups are split (ie. underused
        # blockgroups)
        for BB in $BTRFS_BALANCE_MUSAGE; do
          # quick round to clean up the unused block groups
          run_task btrfs balance start -v -musage=$BB -dusage=$BB "$MM"
        done
      else
        run_task btrfs balance start -dusage=0 "$MM"
        for BB in $BTRFS_BALANCE_DUSAGE; do
          # quick round to clean up the unused block groups
          run_task btrfs balance start -v -dusage=$BB "$MM"
        done
        run_task btrfs balance start -musage=0 "$MM"
        for BB in $BTRFS_BALANCE_MUSAGE; do
          # quick round to clean up the unused block groups
          run_task btrfs balance start -v -musage="$BB" "$MM"
        done
      fi

      echo "After balance of $MM"
      btrfs filesystem df "$MM"
      df -H "$MM"
    done

    exit 0
  ''
