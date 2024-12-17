{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/rootfs" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/";
                  };
                  # Subvolume name is the same as the mountpoint
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                  "/log" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/var/log";
                  };
                  "/cache" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/var/cache";
                  };
                  "/tmp" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/tmp";
                  };
                  # Sub(sub)volume doesn't need a mountpoint as its parent is mounted
                  # "/home/meflove" = { };
                  # Parent is not mounted so the mountpoint must be set
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/nix";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
