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
                  mountOptionsGenerator = {compress ? 1}: [
                    "compress=zstd:${toString compress}"
                    "noatime"
                    "space_cache=v2"
                    "nodiscard"
                    "ssd_spread"
                    "commit=300"
                  ];
                  mountOptions = mountOptionsGenerator {compress = 1;};
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
                    mountOptions = mountOptionsGenerator {compress = 3;};
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
          compression = "zstd-19";
          atime = "off";
          xattr = "sa";
        };

        datasets = {
          data = {
            type = "zfs_fs";

            mountpoint = "/data";
            options = {
              mountpoint = "/data";
            };
          };
        };
      };
    };
  };
}
