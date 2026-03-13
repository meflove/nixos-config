{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.boot.kernel-optimisations;
in {
  options.${namespace}.nixos.boot.kernel-optimisations = {
    enable =
      lib.mkEnableOption "kernel-optimisations"
      // {
        default = false;
        description = "Enable kernel optimisations for better performance.";
      };

    kernelPackage = lib.mkOption {
      type = lib.types.raw;
      default = pkgs.linuxPackages_latest;
      description = "Kernel package to use.";
    };

    cpuGovernor = lib.mkOption {
      type = lib.types.str;
      default = "performance";
      description = ''
        CPU frequency governor to use. Options include "performance", "powersave", "ondemand", etc.
      '';
    };

    enableZfs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable ZFS support.";
    };
  };

  config = mkIf cfg.enable {
    services.scx = {
      enable = true;
      package = pkgs.scx.rustscheds;

      scheduler = "scx_lavd";
      extraArgs = [
        "--performance"
        "--no-core-compaction"
        "--per-cpu-dsq"
      ];
    };

    boot = {
      kernelPackages = cfg.kernelPackage;
      zfs.package = lib.mkIf cfg.enableZfs pkgs.zfs_cachyos;
      supportedFilesystems = lib.mkIf cfg.enableZfs ["zfs"];
      kernelPatches = [
        {
          name = "optimisations";
          patch = null;
          features = {
            optimization = true;
            microcode = true;
          };
        }
        {
          name = "bbr_net_sched";
          patch = null;
          structuredExtraConfig = with pkgs.lib.kernel; {
            TCP_CONG_CUBIC = lib.mkForce module;
            DEFAULT_CUBIC = no;
            TCP_CONG_BBR = yes;
            DEFAULT_BBR = yes;
            NET_SCH_FQ_CODEL = module;
            NET_SCH_FQ = yes;
            CONFIG_DEFAULT_FQ_CODEL = no;
            CONFIG_DEFAULT_FQ = yes;
          };
        }
        {
          name = "disable_brk";
          patch = null;
          structuredExtraConfig = with pkgs.lib.kernel; {
            COMPAT_BRK = no;
          };
        }
        {
          name = "nohz_full";
          patch = null;
          structuredExtraConfig = with pkgs.lib.kernel; {
            HZ_PERIODIC = no;
            NO_HZ_IDLE = no;
            CONTEXT_TRACKING_FORCE = no;
            NO_HZ_FULL_NODEF = yes;
            NO_HZ_FULL = yes;
            NO_HZ = yes;
            NO_HZ_COMMON = yes;
            CONTEXT_TRACKING = yes;
          };
        }
      ];
      kernelModules = [
        "v4l2loopback"
      ];

      initrd = {
        verbose = false;
        systemd.enable = true;
      };

      kernel.sysctl."kernel.sysrq" = 1;
      kernelParams = [
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "quiet"
        "splash"
        "mitigations=off"
        "vt.global_cursor_default=0"
        "lpj=2496000"
        "page_alloc.shuffle=1"
        "pci=pcie_bus_perf"
        "intel_idle.max_cstate=1"
        "bgrt_disable"
        "nowatchdog"
        "ibt=off"
        # Boot optimisations
        "rd.udev.timeout=0" # Don't wait for USB devices
        "8250.nr_uarts=0" # Disable serial ports (ttyS0-31)
      ];
    };

    powerManagement.cpuFreqGovernor = cfg.cpuGovernor;
  };
}
