{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      config,
      ...
    }: let
      wine = pkgs.nix-gaming.wine-tkg;
      # gamePkgs = inputs.nix-gaming.packages.${lib.hostPlatform};
    in {
      boot.kernelModules = [
        "ntsync"
      ];

      users.users = {
        ${lib.userName} = {
          extraGroups = [
            "gamemode"
          ];
        };
      };

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
          capSysNice = false;
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

      environment.systemPackages = lib.attrValues {
        inherit
          (pkgs)
          logiops
          gamescope-wsi_git
          ;
        inherit
          (pkgs.nix-gaming)
          dxvk
          dxvk-nvapi
          vkd3d-proton
          ;
      };

      system.userActivationScripts = {
        kron4ekDlls = let
          installDlls = game: dir:
          # bash
          ''
            GAME_DIR="/home/${lib.userName}/Games/${dir}"

            if [[ -d "$GAME_DIR" ]]; then
              mkdir -p "$GAME_DIR/game_info/dlls"

              ln -sf ${pkgs.nix-gaming.dxvk-w64}/bin/*.dll "$GAME_DIR/game_info/dlls/"
              ln -sf ${pkgs.nix-gaming.dxvk-nvapi-w64}/bin/*.dll "$GAME_DIR/game_info/dlls/"
              ln -sf ${pkgs.nix-gaming.vkd3d-proton-w64}/bin/*.dll "$GAME_DIR/game_info/dlls/"
              ln -sf ${config.hardware.nvidia.package}/lib/nvidia/wine/*.dll "$GAME_DIR/game_info/dlls/"
              echo "Succesfully installed dlls for ${game}"
            else
              echo "There is no ${game} dir \"$GAME_DIR\""

              exit 0
            fi
          '';
        in {
          text =
            (installDlls "Cyberpunk 2077" "Cyberpunk 2077")
            + (installDlls "No Man's Sky" "NoMansSky_Linux")
            + (installDlls "Man Eater" "Maneater_Linux");
        };
      };

      hm = {
        home = {
          packages = let
            heroic = pkgs.heroic.override {
              extraPkgs = pkgs':
                with pkgs'; [
                  config.programs.gamescope.package
                  gamemode
                ];
            };
          in
            lib.attrValues
            {
              inherit
                (pkgs)
                # stuff
                protonup-ng
                cabextract
                ## Games
                # freesmlauncher
                # (gamePkgs.osu-stable.override {
                #   useGameMode = false;
                # })
                # veloren
                # mindustry-wayland
                # shattered-pixel-dungeon
                # osu-lazer-bin
                ;
              inherit
                (pkgs.nix-gaming)
                winetricks-git
                ;
              inherit
                heroic
                ;
            };

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
            package = pkgs.lutris.override {
              # Intercept buildFHSEnv to modify target packages
              buildFHSEnv = args:
                pkgs.buildFHSEnv (args
                  // {
                    multiPkgs = envPkgs: let
                      # Fetch original package list
                      originalPkgs = args.multiPkgs envPkgs;

                      # Disable tests for openldap
                      customLdap = envPkgs.openldap.overrideAttrs (_: {doCheck = false;});
                    in
                      # Replace broken openldap with the custom one
                      builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [customLdap];
                  });
            };

            runners = {
              wine = {
                settings = {
                  system.game_path = "/home/${lib.userName}/Lutris";
                  runner = {
                    runner_executable = "${wine}/bin/wine";
                    version = "system";
                  };
                };
              };
            };
            extraPackages = with pkgs; [
              config.hm.programs.mangohud.package
              config.programs.gamescope.package
              gamemode
              nix-gaming.winetricks-git
              umu-launcher
              vulkan-tools
            ];
            protonPackages = config.programs.steam.extraCompatPackages;
            steamPackage = config.programs.steam.package;
          };
        };
      };
    };
  };
}
