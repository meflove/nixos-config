{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.hardware.nvidia;
in {
  options.${namespace}.nixos.hardware.nvidia = {
    enable =
      lib.mkEnableOption "enable NVIDIA proprietary drivers"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;

        modesetting.enable = true;

        powerManagement.enable = false;
        powerManagement.finegrained = false;

        open = true;

        nvidiaSettings = false;
      };
    };

    environment.sessionVariables = {
      NVD_BACKEND = "direct";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      VDPAU_DRIVER = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
