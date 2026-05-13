{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      config,
      lib,
      ...
    }: {
      fonts = {
        enableDefaultPackages = true;
        enableGhostscriptFonts = true;
        fontDir.enable = true;

        packages = lib.attrValues {
          inherit (pkgs.nerd-fonts) lilex jetbrains-mono;
        };
        fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [config.stylix.fonts.monospace.name];
            sansSerif = [config.stylix.fonts.monospace.name];
            monospace = [config.stylix.fonts.monospace.name];
          };
        };
      };
      stylix = {
        enable = true;
        autoEnable = true;

        image =
          lib.mkStylixImage ../../../pics/nix-tyan.png config.lib.stylix.colors.toList;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
        # base16Scheme = {
        #   scheme = "Tokyo-Night-Storm-MD3e";
        #   name = "TokyoNightStormMD3e";
        #   base00 = "#24283b";
        #   base01 = "#1f2335";
        #   base02 = "#292e42";
        #   base03 = "#565f89";
        #   base04 = "#a9b1d6";
        #   base05 = "#c0caf5";
        #   base06 = "#cdd6f4";
        #   base07 = "#d5d6db";
        #   base08 = "#f7768e";
        #   base09 = "#ff9e64";
        #   base0A = "#e0af68";
        #   base0B = "#9ece6a";
        #   base0C = "#7dcfff";
        #   base0D = "#7aa2f7";
        #   base0E = "#bb9af7";
        #   base0F = "#ff007c";
        # };
        polarity = "dark";

        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.lilex;
            name = "Lilex Nerd Font Mono";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };

          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
          sizes = {
            terminal = 12;
          };
        };

        cursor = {
          name = "Bibata-Modern-Custom";
          package = inputs.nix-cursors.packages.${lib.hostPlatform}.bibata-modern-cursor.override {
            background_color = config.lib.stylix.colors.withHashtag.base0D;
            outline_color = config.lib.stylix.colors.withHashtag.base00;
            accent_color = config.lib.stylix.colors.withHashtag.base00;
          };
          size = 20;
        };
      };
      hm = {
        stylix = {
          targets =
            lib.genAttrs [
              "hyprlock"
              "obsidian"
              "nixcord"
              "gnome"
            ]
            (_: {enable = false;})
            // {
              gtk = {
                fonts.enable = false;
              };
              qt = {
                standardDialogs = "xdgdesktopportal";
              };
              zen-browser.profileNames = ["angeldust"];
            };

          icons = {
            enable = true;
            dark = "Rose-Pine-Dark";
            package = pkgs.rose-pine-icon-theme;
          };
        };

        home = {
          packages = lib.attrValues {
            inherit
              (pkgs)
              gtk3
              gtk4
              ;
          };

          pointerCursor = {
            gtk.enable = true;
            hyprcursor.enable = true;
            dotIcons.enable = true;
            x11.enable = true;
          };
        };

        fonts = {
          fontconfig = {
            enable = true;
            defaultFonts = {
              serif = [config.stylix.fonts.monospace.name];
              sansSerif = [config.stylix.fonts.monospace.name];
              monospace = [config.stylix.fonts.monospace.name];
            };
          };
        };

        dconf = {
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };
          };
        };

        gtk = {
          enable = true;
        };

        qt = {
          enable = true;
        };

        services.awww = {
          enable = true;
        };
      };
    };
  };
}
