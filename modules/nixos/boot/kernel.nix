{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.v4l2loopback
    v4l-utils
  ];

  hardware.xone.enable = true;

  services.scx = {
    enable = true;
    package = pkgs.scx_git.rustscheds;

    scheduler = "scx_lavd";
  };

  boot = {
    # kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride {mArch = "GENERIC_V3";};
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      compressor = "cat";
    };

    consoleLogLevel = 3;

    # kernelPatches = [
    #   {
    #     name = "bbr";
    #     patch = null;
    #     structuredExtraConfig = with pkgs.lib.kernel; {
    #       TCP_CONG_CUBIC = lib.mkForce module;
    #       TCP_CONG_BBR = yes; # enable BBR
    #       DEFAULT_BBR = yes; # use it by default
    #       NET_SCH_FQ_CODEL = module;
    #       NET_SCH_FQ = yes;
    #     };
    #   }
    # ];

    kernelModules = [
      "ntsync"
      "v4l2loopback"
    ];

    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];

    kernelParams = [
      "systemd.show_status=auto"
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
      "kernel.sysrq=1"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];
  };

  powerManagement.cpuFreqGovernor = "perfomance";
}
