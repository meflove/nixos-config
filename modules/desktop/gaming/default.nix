{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: let
      wine = pkgs.nix-gaming.wine-tkg;
      # gamePkgs = inputs.nix-gaming.packages.${lib.hostPlatform};
    in {
      boot.kernelModules = [
        "ntsync"
      ];

      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "ntsync-udev-rules";
          text = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';
          destination = "/etc/udev/rules.d/70-ntsync.rules";
        })
      ];

      programs = {
        wine = {
          enable = true;
          package = wine;
          binfmt = true;
          ntsync = true;
        };
        gamemode = {
          enable = true;

          settings.general.inhibit_screensaver = 0;
        }; # for performance mode

        steam = {
          enable = true; # install steam
          package = pkgs.steam;
          extraCompatPackages = [
            pkgs.proton-ge-bin
          ];

          gamescopeSession = {
            enable = true;
            args = [
              "-W 2560"
              "-H 1440"
              "-r 144"
            ];
          };
        };

        gamescope = {
          enable = true;
          capSysNice = true;
          package = pkgs.gamescope_git;

          args = [
            "-W 2560"
            "-H 1440"
            "-r 144"
          ];
        };
      };

      virtualisation.waydroid = {
        enable = true;
        package = pkgs.waydroid-nftables;
      };

      systemd.tmpfiles.settings = {
        "10-waydroid-config" = {
          "/var/lib/waydroid/waydroid_base.prop" = {
            "f+" = {
              user = "root";
              group = "root";
              mode = "0644";
              argument = "ro.hardware.gralloc=default\nro.hardware.egl=swiftshader\nsys.use_memfd=true";
            };
          };
        };
      };

      hardware = {
        xone.enable = true;
        new-lg4ff.enable = true;
      };

      environment.systemPackages = with pkgs; [
        logiops
        gamescope-wsi_git
        gamescope-wsi32_git

        nix-gaming.vkd3d-proton
        nix-gaming.dxvk
        nix-gaming.dxvk-nvapi
        nix-gaming.dxvk-nvapi-vkreflex-layer
      ];

      hm = {
        home = {
          packages = with pkgs; [
            protonup-ng

            # veloren
            # mindustry-wayland
            # shattered-pixel-dungeon
            # osu-lazer-bin

            wine
            winetricks

            # Fonts for proper Wine UI rendering
            wineWow64Packages.fonts # Wine replacement fonts

            # (gamePkgs.osu-stable.override {
            #   useGameMode = false;
            # })
            freesmlauncher
          ];

          sessionVariables = {
            STEAM_COMPAT_TOOLS_PATH = "\${HOME}/.steam/root/compatibilitytools.d";
          };
        };

        programs = {
          mangohud = {
            enable = true;
            package = pkgs.mangohud_git;
            settings = {
              winesync = true;
              full = true;
            };
          };

          lutris = {
            enable = true;

            extraPackages = with pkgs; [
              mangohud
              winetricks
              gamescope
              gamemode
              umu-launcher
            ];
            defaultWinePackage = wine;
            steamPackage = pkgs.steam;
          };
        };
      };
    };
  };
}
