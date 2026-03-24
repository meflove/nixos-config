{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      lib,
      config,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        # Essential CLI tools for system administration
        coreutils
        file
        killall
        rsync
        tree
        pcre

        # File management and compression
        unzip
        zip
        rar
        unrar
        _7zz-rar

        # Nix related tools
        comma
        nix-output-monitor
        inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
      ];

      services = {
        locate = {
          enable = true;
          package = pkgs.plocate;
          interval = "hourly";
        };
      };

      programs = {
        nh = {
          enable = true;
          package = inputs.nh.packages.${lib.hostPlatform}.default;

          flake = "/home/angeldust/.config/nixos-config"; # sets NH_OS_FLAKE variable for you

          clean = {
            enable = true;
            dates = "weekly";
            extraArgs = "--keep-since 7d --keep 10";
          };
        };
      };
      hm = {
        sops = {
          secrets = {
            pass = {};
            youtube_cookies = {
              mode = "0444";
            };
          };
        };

        home.packages = with pkgs; [
          # === File System & Disk Utilities ===
          # Modern alternatives to standard tools
          dust # Disk usage visualization (du alternative)
          duf # Disk usage/free tool with colors (df alternative)

          # === System Monitoring & Progress ===
          progress # Coreutils progress viewer
          viddy # Modern watch command with TUI
          btop # `top` alternative

          # === CLI Tools & Utilities ===
          blobdrop # TUI for drag-and-drop file transfers to browser/desktop apps
          unixtools.net-tools # Network tools

          # Replacements for standard commands
          ripgrep # `grep` alternative
          ripgrep-all
          sd # `sed` alternative

          # Productivity & Helpers
          fzf # Fuzzy finder
          ggh # SSH connection manager
          tlrc # Simplified man pages
          chafa # Image to terminal converter
          bitwarden-cli # CLI for Bitwarden password manager
          wl-clipboard

          # Video & Media
          inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.yot

          # === Download & Media ===
          python313Packages.downloader-cli # CLI downloader with progress bars
        ];

        services.clipse = {
          enable = true;
          package = inputs.self.packages.${lib.hostPlatform}.clipse;

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
            package = inputs.chaotic.packages.${lib.hostPlatform}.yt-dlp_git;

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
              # --cookies ${config.hm.sops.secrets.youtube_cookies.path}
              --cookies-from-browser firefox:~/.config/zen
            '';
          };

          nix-index = {
            enable = true;
            enableFishIntegration = true;
            package = inputs.nix-index.packages.${lib.hostPlatform}.default;
          };
        };
      };
    };
  };
}
