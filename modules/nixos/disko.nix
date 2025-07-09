{ config, pkgs, lib, inputs, ... }: # Добавьте 'lib' и 'inputs' в аргументы
{
  # Определяем опцию, через которую хост будет передавать целевой диск
  options.myConfig.disk.targetDevice = lib.mkOption {
    type = lib.types.str;
    description = "Целевое дисковое устройство для конфигурации Disko.";
  };

  config = lib.mkIf (config.myConfig.disk.targetDevice != null) {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = config.myConfig.disk.targetDevice; # Используем настраиваемую опцию
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
  };
}

