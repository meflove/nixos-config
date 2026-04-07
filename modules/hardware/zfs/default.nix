{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      boot.zfs.package = pkgs.zfs_cachyos;
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
