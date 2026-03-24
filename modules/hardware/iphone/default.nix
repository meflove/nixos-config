{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      lib,
      ...
    }: {
      services.usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
      };

      environment.systemPackages = with pkgs; [
        libimobiledevice
        idevicerestore

        inputs.self.packages.${lib.hostPlatform}.iloader

        ifuse # optional, to mount using 'ifuse'
      ];
    };
  };
}
