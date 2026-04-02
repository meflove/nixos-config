{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      ...
    }: {
      services.xserver.videoDrivers = ["nvidia"];

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            vulkan-extension-layer
            vulkan-headers
            vulkan-loader
            vulkan-tools
            vulkan-validation-layers
            vulkan-hdr-layer-kwin6

            nvidia-vaapi-driver
            libvdpau-va-gl
          ];
        };

        nvidia = {
          # package = let
          #   base = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          #     version = "590.48.01";
          #     sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
          #     openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
          #     settingsSha256 = "sha256-4SfCWp3swUp+x+4cuIZ7SA5H7/NoizqgPJ6S9fm90fA=";
          #     persistencedSha256 = "";
          #   };
          #   cachyos-nvidia-patch = pkgs.fetchpatch {
          #     url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
          #     sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
          #   };
          #   # Patch the appropriate driver based on config.hardware.nvidia.open
          #   driverAttr =
          #     if config.hardware.nvidia.open
          #     then "open"
          #     else "bin";
          # in
          #   base
          #   // {
          #     ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
          #       patches = (oldAttrs.patches or []) ++ [cachyos-nvidia-patch];
          #     });
          #   };
          package = config.boot.kernelPackages.nvidiaPackages.beta;

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
        # For Accelerated Video Playback support
        MOZ_DISABLE_RDD_SANDBOX = "1";
      };
    };
  };
}
