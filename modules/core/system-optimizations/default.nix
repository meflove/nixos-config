{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      zramSwap = {
        enable = true;
        priority = 100;
        swapDevices = 2;
        memoryPercent = 100;
      };

      systemd.tmpfiles.settings = {
        "90-page-trashing" = {
          "/sys/kernel/mm/lru_gen/min_ttl_ms" = {
            "w!" = {
              argument = "2000";
            };
          };
        };
      };

      hardware = {
        ksm.enable = true;

        block.scheduler = {
          "sd[a-z]*" = "bfq";
          "mmcblk[0-9]*" = "mq-deadline";
          "nvme[0-9]*" = "none";
        };
        cpu.intel.updateMicrocode = true;
      };

      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "IO-schedulers-udev-rules";
          text = ''
            # HDD
            ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

            # SSD
            ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"

            # NVMe SSD
            ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"
          '';
          destination = "/etc/udev/rules.d/60-ioschedulers.rules";
        })
      ];

      boot = {
        extraModprobeConfig = ''
          # HDD optimisations
          options libahci ignore_sss=1

          # Watchdog timers
          blacklist sp5100-tco
          blacklist iTCO_wdt
        '';

        kernel.sysctl = {
          # Zram
          "vm.swappiness" = 150;
          "vm.page-cluster" = 0;

          # Page Trashing
          "vm.dirty_background_bytes" = 256 * 1024 * 1024; # 256MB = 268435456
          "vm.dirty_bytes" = 1 * 1024 * 1024 * 1024; # 2GB = 2147483648

          "vm.dirty_expire_centisecs" = 1500;
          "vm.dirty_writeback_centisecs" = 100;

          # VFS
          "vm.vfs_cache_pressure" = 50;

          # Memory map
          "vm.max_map_count" = 1048576;

          # Watchdog timers
          "kernel.watchdog" = 0;

          # Network optimizations (complementing kernel-level BBR)
          "net.ipv4.tcp_slow_start_after_idle" = 0;
          "net.ipv4.tcp_fastopen" = 3;
          "net.ipv4.tcp_mtu_probing" = 1;
        };

        tmp.useZram = true;
      };

      services = {
        ananicy = {
          enable = true;
          package = pkgs.ananicy-cpp;

          rulesProvider = pkgs.ananicy-rules-cachyos_git;
        };
        dbus.implementation = "broker";

        fwupd.enable = true;
      };
    };
  };
}
