{
  lib,
  namespace,
  config,
  pkgs,
  ...
}: let
  cfg = config.home.${namespace}.desktop.waybar;
in {
  options.home.${namespace}.desktop.waybar.enable =
    lib.mkEnableOption ''
      Waybar - highly customizable Wayland status bar for Sway and Wlroots-based compositors
    ''
    // {
      default = true;
    };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      style = import ./style.nix {
        inherit config;
      };

      settings = import ./settings.nix {
        inherit pkgs lib config;
      };
    };

    # Add required packages for waybar modules
    home.packages = with pkgs; [
      playerctl # For MPRIS module
      waybar-mpris
    ];

    # Wayland window manager settings
    wayland.windowManager.hyprland = lib.mkIf config.home.desktop.hyprland.enable {
      settings = {
        # Layerrules для фикс чёрного бокса
        layerrule = [
          "match:title waybar, blur 0"
        ];
      };
    };
  };
}
