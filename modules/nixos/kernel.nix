{ pkgs, lib, config, ... }: {

  nixpkgs.localSystem = { system = "x86_64-linux"; };

  hardware.xone.enable = true;

  services.scx = {
    enable = true;
    package = pkgs.scx_git.full;

    scheduler = "scx_lavd";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;

    consoleLogLevel = 3;

    initrd = {
      enable = true;
      verbose = false;
      systemd = {
        enable = true;
        tpm2.enable = true;
      };
    };
  };

  boot.kernelPatches = [{
    name = "bbr";
    patch = null;
    structuredExtraConfig = with pkgs.lib.kernel; {
      TCP_CONG_CUBIC = lib.mkForce module;
      TCP_CONG_BBR = yes; # enable BBR
      DEFAULT_BBR = yes; # use it by default
      NET_SCH_FQ_CODEL = module;
      NET_SCH_FQ = yes;
    };
  }];

  boot.kernelParams = [
    "systemd.show_status=auto"
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

  powerManagement.cpuFreqGovernor = "perfomance";

}
