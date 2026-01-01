{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # Используем настраиваемую опцию
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
                mountOptions = ["umask=0077"];
              };
            };
            btrfs = {
              size = "100%"; # Использовать оставшееся пространство для Btrfs
              label = "disk-main-btrfs"; # Явно задаем метку раздела
              content = {
                type = "btrfs"; # Важно: используйте тип "btrfs" для поддержки подтомов
                extraArgs = ["-f"]; # Принудительное создание файловой системы
                subvolumes = {
                  "@root" = {
                    mountpoint = "/";
                    # Параметры монтирования для основного монтирования Btrfs (применяются ко всей файловой системе)
                    mountOptions = [
                      "compress-force=zstd:3"
                      "noatime"
                      "space_cache=v2"
                      "nodiscard"
                      "ssd_spread"
                      "commit=300"
                    ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    # Параметры монтирования для /home (нет необходимости повторять общесистемные параметры)
                    mountOptions = [
                      "compress-force=zstd:3"
                      "noatime"
                      "space_cache=v2"
                      "nodiscard"
                      "ssd_spread"
                      "commit=300"
                    ]; # noatime применяется для каждой точки монтирования
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress-force=zstd:3"
                      "noatime"
                      "space_cache=v2"
                      "nodiscard"
                      "ssd_spread"
                      "commit=300"
                    ]; # noatime применяется для каждой точки монтирования
                  };
                  "@var/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress-force=zstd:3"
                      "noatime"
                      "space_cache=v2"
                      "nodiscard"
                      "ssd_spread"
                      "commit=300"
                    ];
                  };
                  "@var/cache" = {
                    mountpoint = "/var/cache";
                    mountOptions = [
                      "compress-force=zstd:3"
                      "noatime"
                      "space_cache=v2"
                      "nodiscard"
                      "ssd_spread"
                      "commit=300"
                    ];
                  };
                  "@.snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [
                      "compress-force=zstd:3"
                      "noatime"
                      "space_cache=v2"
                      "nodiscard"
                      "ssd_spread"
                      "commit=300"
                    ];
                  };
                  "@srv" = {
                    mountpoint = "/srv";
                    mountOptions = [
                      "compress-force=zstd:3"
                      "noatime"
                      "space_cache=v2"
                      "nodiscard"
                      "ssd_spread"
                      "commit=300"
                    ];
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
