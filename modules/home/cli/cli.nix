{
  inputs,
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.cli.basic-stuff;
in {
  options.home.${namespace}.cli.basic-stuff = {
    enable =
      lib.mkEnableOption "enable basic CLI tools and configurations"
      // {
        default = config.home.${namespace}.cli.fishShell.enable;
      };
  };

  config = mkIf cfg.enable {
    sops = {
      secrets.pass = {};
    };

    home.packages = with pkgs; [
      # === File System & Disk Utilities ===
      # Modern alternatives to standard tools
      dust # Disk usage visualization (du alternative)
      duf # Disk usage/free tool with colors (df alternative)

      # === System Monitoring & Progress ===
      progress # Coreutils progress viewer
      viddy # Modern watch command with TUI

      # === CLI Tools & Utilities ===
      kalker # Calculator with support for units and functions
      blobdrop # TUI for drag-and-drop file transfers to browser/desktop apps

      # === Download & Media ===
      python313Packages.downloader-cli # CLI downloader with progress bars
    ];

    services.clipse = {
      enable = true;
      package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.clipse;

      historySize = 5000;
      imageDisplay.type = "sixel";
    };

    programs = {
      eza = {
        enable = true;

        git = true;
        icons = "always";
        colors = "always";

        extraOptions = [
          "-a"
          "-1"
        ];
      };

      fd = {
        enable = true;
        hidden = true;
        ignores = [".git/"];
      };

      bat = {
        enable = true;
        config = {
          theme = "Catppuccin Macchiato";
        };
        themes = {
          catppuccinMacchiato = {
            src = pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/catppuccin/bat/refs/heads/main/themes/Catppuccin%20Macchiato.tmTheme";
              sha256 = "sha256-EQCQ9lW5cOVp2C+zeAwWF2m1m6I0wpDQA5wejEm7WgY=";
            };

            file = "Catppuccin Macchiato.tmTheme";
          };
        };
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      starship = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          os = {
            disabled = false;
            format = "$symbol  ";
            symbols.NixOS = "";
          };
        };
      };

      yt-dlp = {
        enable = true;
        package = inputs.chaotic.packages.${pkgs.stdenv.hostPlatform.system}.yt-dlp_git;

        settings = {
          embed-thumbnail = true;
          embed-metadata = true;
          embed-subs = true;
          sub-langs = "all";
          # Use internal downloader to avoid 403 errors from YouTube
          # downloader = lib.getExe pkgs.aria2;
          # downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
        };
        extraConfig = ''
          -S res,ext:mp4:m4a --recode mp4
        '';
      };

      nix-index = {
        enable = true;
        enableFishIntegration = true;
        package = inputs.nix-index.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
    };
  };
}
