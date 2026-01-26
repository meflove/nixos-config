{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.networking.vpn;
in {
  options.${namespace}.nixos.networking.vpn = {
    enable =
      lib.mkEnableOption "Enable VPN services"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [];

    programs.throne = {
      enable = true;

      tunMode.enable = true;
    };

    services = {
    };
  };
}
