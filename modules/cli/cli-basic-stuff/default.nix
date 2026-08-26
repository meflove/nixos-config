{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      ...
    }: {
      environment.systemPackages = lib.attrValues {
        inherit
          (pkgs)
          # Essential CLI tools for system administration
          coreutils-full
          util-linux
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
          ;
      };

      services = {
        locate = {
          enable = true;
          package = pkgs.plocate;
          interval = "hourly";
        };
      };

      hm = {
        sops = {
          secrets = {
            pass = {};
          };
        };

        home.packages = lib.attrValues {
          inherit
            (pkgs)
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
            gopass # CLI password manager
            wl-clipboard
            jq
            ;
          inherit
            (pkgs.angeldust-pkgs)
            # Video & Media
            yot
            ;
          inherit
            (pkgs.python3Packages)
            # === Download & Media ===
            downloader-cli # CLI downloader with progress bars
            ;
        };

        services.clipse = {
          enable = true;
          package = pkgs.angeldust-pkgs.clipse;

          settings = {
            maxHistory = 5000;
            imageDisplay.type = "kitty";
          };
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
          };

          zoxide = {
            enable = true;
            enableFishIntegration = true;
            enableNushellIntegration = true;
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
            # package = inputs.chaotic.packages.${lib.hostPlatform}.yt-dlp_git;

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
              --cookies-from-browser firefox:~/.config/zen
            '';
          };
        };
      };
    };
  };
}
