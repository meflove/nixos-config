{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      services.usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };

      environment.systemPackages = with pkgs; [
        libimobiledevice
        idevicerestore

        mefPkgs.iloader

        ifuse # optional, to mount using 'ifuse'
      ];
    };
  };
}
