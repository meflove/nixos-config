{
  inputs,
  pkgs,
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.desktop.niri;

  settings = import ./settings.nix {
    inherit pkgs lib config inputs;
  };
in {
  options.home.${namespace}.desktop.niri = {
    enable =
      lib.mkEnableOption "Enable niri window manager"
      // {default = true;};
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        WLR_NO_HARDWARE_CURSORS = "1";

        XDG_SESSION_TYPE = "wayland";
        WLR_RENDERER = "vulkan";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        NIXOS_OZONE_WL = "1";
      };
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;

      inherit settings;
    };

    # XDG portal configuration
    xdg.portal = {
      config.niri = {
        default = ["gtk" "gnome"];
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
