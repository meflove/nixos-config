{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.desktop.gaming.hyprscope;
in {
  imports = [./hm-module.nix];

  options.home.${namespace}.desktop.gaming.hyprscope = {
    enable =
      lib.mkEnableOption ''
        enable Hyprscope - a Hyprland gamescope wrapper
      ''
      // {default = config.home.${namespace}.desktop.gaming.enable;};
  };

  config = mkIf cfg.enable {
    programs.hyprscope = {
      enable = true;

      gamescopeArgs = [
        # Enable adaptive sync
        "--adaptive-sync"
      ];

      gamemodeIntegration = true;
    };
  };
}
