{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda"; # Используем настраиваемую опцию
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G"; # Минимум 512M, 1G рекомендуется для гибкости
              type = "EF00"; # Тип раздела EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi"; # Точка монтирования EFI
                mountOptions = [ "umask=0077" ];
              };
            };
            btrfs = {
              size = "100%"; # Использовать оставшееся пространство для Btrfs
              part-label = "disk-main-btrfs"; # Явно задаем метку раздела
              content = {
                type = "btrfs"; # Важно: используйте тип "btrfs" для поддержки подтомов
                extraArgs = [ "-f" ]; # Принудительное создание файловой системы
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    # Параметры монтирования для основного монтирования Btrfs (применяются ко всей файловой системе)
                    mountOptions = [ "compress-force=zstd:3" "noatime" "space_cache=v2" "nodiscard" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    # Параметры монтирования для /home (нет необходимости повторять общесистемные параметры)
                    mountOptions = [ "noatime" ]; # noatime применяется для каждой точки монтирования
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "noatime" ]; # noatime применяется для каждой точки монтирования
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
