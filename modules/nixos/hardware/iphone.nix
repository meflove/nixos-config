{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.harware.iphone;
in {
  options.${namespace}.nixos.harware.iphone = {
    enable =
      lib.mkEnableOption "enable support for iPhone/iPad connectivity via usbmuxd"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    services.usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };

    environment.systemPackages = with pkgs; [
      libimobiledevice
      idevicerestore

      ifuse # optional, to mount using 'ifuse'
    ];
  };
}
