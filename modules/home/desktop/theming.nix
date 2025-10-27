{
  pkgs,
  inputs,
  lib,
  config,
  namespace,
  system,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.theming;
in {
  options.${namespace}.home.desktop.theming = {
    enable =
      lib.mkEnableOption "enable desktop theming settings"
      // {
        default = config.${namespace}.home.desktop.hyprland.enable;
      };
  };

  config = mkIf cfg.enable {
    home = {
      pointerCursor = {
        gtk.enable = true;
        hyprcursor.enable = true;

        package = inputs.nix-cursors.packages.${system}.bibata-modern-cursor.override {
          background_color = "#${config.colorScheme.palette.base00}";
          outline_color = "#${config.colorScheme.palette.base06}";
          accent_color = "#${config.colorScheme.palette.base00}";
        };
        name = "Bibata-Modern-Custom";
        size = 20;
      };
    };

    colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["JetBrainsMono NF SemiBold"];
        sansSerif = ["JetBrainsMono NF SemiBold"];
        monospace = ["JetBrainsMono NF SemiBold"];
      };
    };

    dconf = {
      settings = {
        "org/gnome/desktop/background" = {
          picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    gtk = {
      enable = true;

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };
  };
}
