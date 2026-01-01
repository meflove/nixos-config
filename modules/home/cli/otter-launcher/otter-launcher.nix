{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.cli.otter-launcher;
in {
  options.home.${namespace}.cli.otter-launcher = {
    enable =
      lib.mkEnableOption "enable otter-launcher"
      // {
        default = config.home.${namespace}.desktop.hyprland.enable;
      };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      krabby
    ];

    programs.otter-launcher = {
      enable = true;
    };

    # source config due to problems with unicode in nix to toml conversion
    xdg.configFile."otter-launcher/config.toml".source = ./config.toml;
  };
}
