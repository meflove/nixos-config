# Этот файл предназначен для прямого использования с 'nix run github:nix-community/disko'
# Он принимает аргумент 'disks', который вы передаете через '--arg disks'
{ disks ? [ "/dev/nvme0n1" ], ... }: # Принимаем аргумент 'disks', по умолчанию используем "/dev/vda"
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 0; # Используем первый диск из переданного списка
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
                extraArgs = [ "-f" ]; # Перезаписать существующий раздел
                subvolumes = {
                  "/rootfs" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/";
                  };
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
