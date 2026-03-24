{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      inputs,
      ...
    }: {
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
        gamemode = {
          enable = true;

          settings.general.inhibit_screensaver = 0;
        }; # for performance mode

        steam = {
          enable = true; # install steam
          package = pkgs.steam;

          gamescopeSession.enable = true;
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
      ];

      hm = let
        wine = pkgs.wineWow64Packages.stagingFull;
        # gamePkgs = inputs.nix-gaming.packages.${lib.hostPlatform};
      in {
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
            corefonts # Microsoft Core Fonts (Arial, Times New Roman, Courier New)
            vista-fonts # Vista fonts (Calibri, Cambria, Candara, Consolas, Constantia, Corbel)
            wineWow64Packages.fonts # Wine replacement fonts

            # (gamePkgs.osu-stable.override {
            #   useGameMode = false;
            # })

            (inputs.freesmlauncher.packages.${lib.hostPlatform}.freesmlauncher.overrideAttrs (_: previousAttrs: {
              meta =
                previousAttrs.meta
                // {
                  maintainers = with lib.maintainers; [s0me1newithhand7s];
                };
            }))
          ];

          sessionVariables = {
            STEAM_COMPAT_TOOLS_PATH = "\${HOME}/.steam/root/compatibilitytools.d";
          };
        };

        programs = {
          mangohud = {
            enable = true;
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
