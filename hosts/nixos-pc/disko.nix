{devices, ...}: {
  disko.devices = {
    disk = {
      # BTRFS
      main = {
        type = "disk";
        device = devices.main-disk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
                mountOptions = ["umask=0077"];
              };
            };
            btrfs = {
              size = "100%";
              label = "disk-main-btrfs";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = let
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                    "space_cache=v2"
                    "nodiscard"
                    "ssd_spread"
                    "commit=300"
                  ];
                in {
                  "@root" = {
                    mountpoint = "/";
                    inherit mountOptions;
                  };
                  "@home" = {
                    mountpoint = "/home";
                    inherit mountOptions;
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    inherit mountOptions;
                  };
                  "@var/log" = {
                    mountpoint = "/var/log";
                    inherit mountOptions;
                  };
                  "@var/cache" = {
                    mountpoint = "/var/cache";
                    inherit mountOptions;
                  };
                  "@.snapshots" = {
                    mountpoint = "/.snapshots";
                    inherit mountOptions;
                  };
                  "@srv" = {
                    mountpoint = "/srv";
                    inherit mountOptions;
                  };
                };
              };
            };
          };
        };
      };
      # ZFS
      intel-ssd = {
        type = "disk";
        device = devices.zfs-disk;
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "ztest";
              };
            };
          };
        };
      };
    };
    zpool = {
      ztest = {
        type = "zpool";

        options = {
          ashift = "12";
          autotrim = "on";
        };

        rootFsOptions = {
          compression = "zstd";
          atime = "off";
          xattr = "sa";
          mountpoint = "none";
        };

        mountpoint = "/data";

        datasets = {
          test = {
            type = "zfs_fs";
            mountpoint = "/data";
            mountOptions = ["noauto"];
            options = {
              recordsize = "128K";
            };
          };

          test2 = {
            type = "zfs_fs";
            mountpoint = "/data2";
            mountOptions = ["noauto"];
            options = {
              recordsize = "16K";
              compression = "lz4";
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=8192M"
        ];
      };
    };
  };
}
