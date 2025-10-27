{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.vpn;
in {
  options.${namespace}.nixos.core.vpn = {
    enable =
      lib.mkEnableOption "Enable VPN services"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    programs.nekoray = {
      enable = true;

      tunMode.enable = true;
    };
  };
}
