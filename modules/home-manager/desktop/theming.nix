{ inputs, pkgs, ... }:
{
  home = {
    pointerCursor = {
      gtk.enable = true;
      hyprcursor.enable = true;

      package = inputs.nix-cursors.packages.${pkgs.system}.apple-cursor;
      name = "Apple-Custom";
      size = 20;
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-storm;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "JetBrainsMono NF SemiBold" ];
      sansSerif = [ "JetBrainsMono NF SemiBold" ];
      monospace = [ "JetBrainsMono NF SemiBold" ];
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
}
