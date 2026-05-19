{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      services.xserver.videoDrivers = ["nvidia"];

      hardware = {
        graphics = {
          enable = true;

          extraPackages = lib.attrValues {
            inherit
              (pkgs)
              nvidia-vaapi-driver
              libvdpau-va-gl
              gamescope-wsi_git
              vulkan-hdr-layer-kwin6
              vulkan-extension-layer
              vulkan-loader
              vulkan-headers
              vulkan-validation-layers
              vulkan-tools
              ;
            inherit
              (pkgs.nix-gaming)
              dxvk-nvapi-vkreflex-layer
              ;
          };
        };

        nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.latest;

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
