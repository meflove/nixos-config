{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      pkgs,
      inputs,
      ...
    }: {
      boot.zfs.package = config.boot.kernelPackages.zfs_cachyos;
      # boot.zfs.package = pkgs.cachyosKernels.zfs-cachyos.override {
      #   kernel = config.boot.kernelPackages.kernel;
      # };
      services.zfs = {
        zed = {
          settings = {
            ZED_DEBUG_LOG = "/tmp/zed.debug.log";

            ZED_NOTIFY_INTERVAL_SECS = 3600;
            ZED_NOTIFY_VERBOSE = true;
          };
        };
      };
    };
  };
}
