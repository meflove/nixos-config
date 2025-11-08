{
  pkgs,
  lib,
  inputs,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.gaming;
in {
  options.${namespace}.home.desktop.gaming = {
    enable =
      lib.mkEnableOption "enable gaming optimizations and tools"
      // {
        default = false;
      };

    wine = {
      enable =
        lib.mkEnableOption "enable wine"
        // {
          default = true;
        };
      package =
        lib.mkPackageOption pkgs "wine package to use"
        {
          default = pkgs.wineWowPackages.stagingFull;
        };
    };

    lutris.enable =
      lib.mkEnableOption "enable Lutris game manager"
      // {
        default = false;
      };

    minecraft.enable =
      lib.mkEnableOption "enable Minecraft launcher and optimizations"
      // {
        default = false;
      };

    osu.enable =
      lib.mkEnableOption "enable osu! stable client via nix-gaming"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; let
        gamePkgs = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system};
      in
        [
          protonup-ng

          # veloren
          # mindustry-wayland
          # shattered-pixel-dungeon
          # osu-lazer-bin
        ]
        ++ lib.optionals cfg.wine.enable [
          cfg.wine.package
          winetricks
        ]
        ++ lib.optionals cfg.osu.enable [
          (gamePkgs.osu-stable.override {
            useGameMode = false;
          })
        ]
        ++ lib.optionals cfg.minecraft.enable [
          (inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher.overrideAttrs (_: previousAttrs: {
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
        inherit (cfg.lutris) enable;

        extraPackages = with pkgs; [
          mangohud
          winetricks
          gamescope
          gamemode
          umu-launcher
        ];
        defaultWinePackage = cfg.wine.package;
        steamPackage = pkgs.steam;
      };
    };
  };
}
