{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
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
          "vm.dirty_background_bytes" = 268435456;
          "vm.dirty_bytes" = 1073741824;

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
        earlyoom = {
          enable = true;

          enableNotifications = true;
        };

        dbus.implementation = "broker";

        fwupd.enable = true;
      };
    };
  };
}
