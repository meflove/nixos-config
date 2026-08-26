{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
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
