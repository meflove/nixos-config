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
        forceImportRoot = false;
        extraPools =
          if config.boot.supportedFilesystems ? "zfs"
          then lib.attrNames inputs.self.diskoConfigurations.${lib.configurationName}.disko.devices.zpool
          else [];
      };

      fileSystems = let
        zfsPools = inputs.self.diskoConfigurations.${lib.configurationName}.disko.devices.zpool or {};

        mkZfsFileSystems = pools: let
          mkPoolFileSystems = _poolName: poolConfig:
            lib.foldlAttrs (
              fsResult: _datasetName: datasetConfig:
                fsResult
                // (
                  if datasetConfig.type or "" == "zfs_fs"
                  then let
                    mountpoint = datasetConfig.options.mountpoint or null;
                  in
                    if mountpoint != null && mountpoint != "none" && mountpoint != "legacy"
                    then {"${mountpoint}".options = ["noauto"];}
                    else {}
                  else {}
                )
            ) {} (poolConfig.datasets or {});
        in
          lib.foldlAttrs (result: name: value: result // mkPoolFileSystems name value) {} pools;
      in
        mkZfsFileSystems zfsPools;

      services.zfs = {
        zed = {
          settings = {
            ZED_DEBUG_LOG = "/var/log/zed.debug.log";

            ZED_NOTIFY_INTERVAL_SECS = 3600;
            ZED_NOTIFY_VERBOSE = true;
          };
        };
      };
    };
  };
}
