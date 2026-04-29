{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      inputs,
      ...
    }: {
      boot.zfs = {
        package = config.boot.kernelPackages.zfs_cachyos;
        extraPools =
          if config.boot.supportedFilesystems ? "zfs"
          then lib.attrNames inputs.self.diskoConfigurations.${lib.configurationName}.disko.devices.zpool
          else [];
      };

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
