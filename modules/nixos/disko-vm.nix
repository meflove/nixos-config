{ config, pkgs, lib, ... }:
let
  targetDisk = "/dev/vda";
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = targetDisk;
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
                mountOptions = [ "umask=0077" ];
              };
            };
            btrfs = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress-force=zstd:3" "noatime" "space_cache=v2" "nodiscard" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "noatime" ];
                  };
                  "/var/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "noatime" ];
                  };
                  "/var/cache" = {
                    mountpoint = "/var/cache";
                    mountOptions = [ "noatime" ];
                  };
                  "/.snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [ "noatime" ];
                  };
                  "srv" = {
                    mountpoint = "/srv";
                    mountOptions = [ "noatime" ];
                  };
                  "tmp" = {
                    mountpoint = "/tmp";
                    mountOptions = [ "noatime" ];
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
