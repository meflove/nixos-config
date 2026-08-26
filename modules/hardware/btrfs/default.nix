{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      config,
      ...
    }: let
      btrfsBalance = import ./btrfs-balance.nix {inherit pkgs lib;};

      # Upstream defaults: https://github.com/kdave/btrfsmaintenance
      # (sysconfig.btrfsmaintenance)
      balanceMountpoints = "/"; # ":"-separated; "auto" = all mounted btrfs filesystems
      balanceDusage = "5 10"; # usage thresholds (%) for data block groups
      balanceMusage = "5"; # usage thresholds (%) for metadata block groups
      balanceOnCalendar = "weekly";
      balanceAllowConcurrency = false;

      btrfsSupported = config.boot.supportedFilesystems ? "btrfs";
    in {
      environment.systemPackages = lib.attrValues {
        inherit
          (pkgs)
          btrfs-progs
          ;
      };

      services =
        lib.mkIf btrfsSupported
        {
          btrfs.autoScrub = {
            enable = true;
          };
          beesd.filesystems.root = {
            spec = "/";
            hashTableSizeMB = 256;
            verbosity = "crit";
            extraOptions = [
              "--loadavg-target"
              "5.0"
              "--throttle-factor"
              "1.0"
            ];
          };
        };

      systemd =
        lib.mkIf btrfsSupported
        {
          # Upstream unit template: btrfs-balance.service
          services.btrfs-balance = {
            description = "Balance block groups on a btrfs filesystem";
            documentation = ["man:btrfs-balance(8)"];
            after = ["fstrim.service"];

            serviceConfig = {
              Type = "simple";
              ExecStart = btrfsBalance;
              IOSchedulingClass = "idle";
              CPUSchedulingPolicy = "idle";
            };

            environment = {
              BTRFS_BALANCE_MOUNTPOINTS = balanceMountpoints;
              BTRFS_BALANCE_DUSAGE = balanceDusage;
              BTRFS_BALANCE_MUSAGE = balanceMusage;
              BTRFS_ALLOW_CONCURRENCY = lib.boolToString balanceAllowConcurrency;
            };
          };

          timers.btrfs-balance = {
            wantedBy = ["timers.target"];
            timerConfig = {
              OnCalendar = balanceOnCalendar;
              AccuracySec = "1h";
              Persistent = true;
            };
          };
        };
    };
  };
}
