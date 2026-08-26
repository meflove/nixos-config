{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      config,
      ...
    }: let
      # wine = pkgs.wineWow64Packages.stagingFull;
      wine = pkgs.nix-gaming.wine-tkg;
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
          package = pkgs.steam.override {
            extraProfile = ''
              export PROTON_ENABLE_WAYLAND=1
            '';
          };
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

          config = {
            enable = true;
            desktopEntries.enable = true;
            onSteamRunning = "close";
            defaultCompatTool = pkgs.proton-ge-bin;

            apps = let
              wrappers = [
                (lib.getExe pkgs.gamemode)
              ];

              env = {
                DXVK_CONFIG = "dxvk.trackPipelineLifetime = True; dxvk.enableAsync = True;";
                PROTON_LOCAL_SHADER_CACHE = 1;
                PROTON_USE_NTSYNC = 1;
                PROTON_ENABLE_WAYLAND = 1;
                LOW_LATENCY_LAYER = 1;
                LOW_LATENCY_LAYER_REFLEX = 1;
                "__GL_SHADER_DISK_CACHE_SKIP_CLEANUP" = 1;
                "__GL_SHADER_DISK_CACHE_SIZE" = 12884901888;
              };
            in {
              "2357570" = {
                inherit wrappers;
                env =
                  {
                    DXVK_HUD = "compiler";
                    VKD3D_FEATURE_LEVEL = "12_2";
                  }
                  // env;
                args = [
                  "-dx12"
                ];
              };
            };
          };
        };

        gamescope = {
          enable = true;
          enableWsi = true;
          capSysNice = false;
          # package = pkgs.gamescope_git;

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
          ;
      };

      system.userActivationScripts = {
        gamesDirDlls = {
          text =
            # bash
            ''
              GAMES_DIR="/home/${lib.userName}/.wine"
              wine=${lib.getExe config.programs.wine.package}

              if [[ -d "$GAMES_DIR" ]]; then
                export WINEPREFIX="$GAMES_DIR"

                ln -sf ${pkgs.nix-gaming.dxvk-w64}/bin/*.dll "$GAMES_DIR/drive_c/windows/system32/"
                ln -sf ${pkgs.nix-gaming.dxvk-nvapi-w64}/bin/*.dll "$GAMES_DIR/drive_c/windows/system32/"
                ln -sf ${pkgs.nix-gaming.vkd3d-proton-w64}/bin/*.dll "$GAMES_DIR/drive_c/windows/system32/"
                ln -sf ${config.hardware.nvidia.package}/lib/nvidia/wine/*.dll "$GAMES_DIR/drive_c/windows/system32/"

                # dxvk
                $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v d3d8 /d native,builtin /f
                $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v d3d9 /d native,builtin /f
                $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v d3d10core /d native,builtin /f
                $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v d3d11 /d native,builtin /f
                $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v dxgi /d native,builtin /f

                # dxvk-nvapi
                $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v nvapi /d native,builtin /f
                $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v nvapi64 /d native,builtin /f

                # vkd3d
                $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v d3d12 /d native,builtin /f
                $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v d3d12core /d native,builtin /f

                echo "Succesfully installed dlls for \"Games\" dir"
              else
                echo "There is no \"Games\" dir"
                exit 0
              fi
            '';
        };
        kron4ekDlls = let
          installDlls = game: dir:
          # bash
          ''
            GAME_DIR="/home/${lib.userName}/Games/${dir}"

            if [[ -d "$GAME_DIR" ]]; then
              mkdir -p "$GAME_DIR/game_info/dlls"

              ln -sf ${config.programs.wine.package}/lib/wine/x86_64-windows/d3dcompiler_*.dll "$GAME_DIR/game_info/dlls/"

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
            + (installDlls "Assassin’s Creed: Origins" "ACOrigins_Linux")
            + (installDlls "Marvel’s Spider-Man Remastered" "SpiderMan_Linux");
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
                freesmlauncher
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
            STEAM_COMPAT_TOOLS_PATH = "/home/${lib.userName}/.steam/root/compatibilitytools.d";
          };
        };

        systemd.user.services = {
          steam-autostart = {
            Unit = {
              PartOf = ["graphical-session.target"];
              After = ["graphical-session.target"];
            };

            Install = {
              WantedBy = ["graphical-session.target"];
            };

            Service = {
              ExecStart = lib.concatStringsSep " " [
                (lib.getExe config.programs.steam.package)
                "-nochatui"
                "-nofriendsui"
                "-silent"
              ];
              Restart = "always";
            };
          };
        };

        programs = {
          mangohud = {
            enable = true;
            package = pkgs.mangohud_git;
            settingsPerApplication = {
              wine-Overwatch = {
                fps = true;
                display_server = true;
                winesync = true;
                frametime = false;
                frame_timing = false;
                cpu_stats = false;
                gpu_stats = false;
              };
            };
          };
          lutris = {
            enable = true;

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
