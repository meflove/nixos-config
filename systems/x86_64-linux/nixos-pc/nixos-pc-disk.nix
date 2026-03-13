{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_S649NL0W301613B";
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
