{
  pkgs,
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
      lib.mkEnableOption ''
        Enable NVIDIA proprietary drivers with gaming optimizations.

        This configures NVIDIA drivers with the following optimizations:
        - Beta drivers for latest features and performance improvements
        - Open kernel modules for better Wayland compatibility
        - Modesetting enabled for better performance
        - Power management disabled for maximum gaming performance
        - 32-bit support for Wine/Proton compatibility layer
        - Proper Wayland environment variables for optimal GPU performance

        Recommended for gaming and GPU-intensive workloads.
      ''
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    # Assertions to validate NVIDIA configuration
    assertions = [
      {
        assertion = config.hardware.graphics.enable;
        message = "NVIDIA drivers require graphics stack to be enabled. Please enable hardware.graphics.enable.";
      }
      {
        assertion = builtins.elem "nvidia" config.services.xserver.videoDrivers;
        message = "NVIDIA module requires nvidia driver in services.xserver.videoDrivers.";
      }
      {
        assertion = config.hardware.graphics.enable32Bit;
        message = "NVIDIA drivers require 32-bit graphics support for Wine/Proton compatibility.";
      }
    ];

    # Load NVIDIA DRM kernel modules early for proper Wayland support
    boot = {
      initrd.kernelModules = ["nvidia" "nvidia-drm"];

      # Enable nvidia-drm modeset for Wayland support
      kernelParams = ["nvidia-drm.modeset=1"];
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          # Vulkan stack for GPU acceleration and gaming
          vulkan-extension-layer
          vulkan-headers
          vulkan-loader
          vulkan-tools
          vulkan-validation-layers
          vulkan-hdr-layer-kwin6
        ];
      };

      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "590.44.01";
          sha256_64bit = "sha256-VbkVaKwElaazojfxkHnz/nN/5olk13ezkw/EQjhKPms=";
          sha256_aarch64 = "";
          openSha256 = "sha256-ft8FEnBotC9Bl+o4vQA1rWFuRe7gviD/j1B8t0MRL/o=";
          settingsSha256 = "";
          persistencedSha256 = lib.fakeSha256;
        };

        modesetting.enable = true;

        powerManagement = {
          enable = false;
          finegrained = false;
        };

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
