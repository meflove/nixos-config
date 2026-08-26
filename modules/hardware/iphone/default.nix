{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      ...
    }: {
      services.usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };

      environment.systemPackages = lib.attrValues {
        inherit
          (pkgs)
          libimobiledevice
          idevicerestore
          ifuse # optional, to mount using 'ifuse'
          # iloader
          ;
      };

      hm = {
        programs.blueferry = {
          enable = true;
          package = pkgs.angeldust-pkgs.blueferry-quickshell;
        };
      };
    };
  };
}
