{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      pkgs,
      ...
    }: {
      environment.systemPackages = lib.attrValues {
        inherit
          (pkgs)
          usbutils
          gphoto2
          gphoto2fs
          ;
      };

      hardware.usbStorage.manageShutdown = true;
      services.gvfs.enable = true;
    };
  };
}
