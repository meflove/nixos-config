{
  pkgs,
  inputs,
  lib,
  config,
  namespace,
  system,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.desktop.gaming;
in {
  options.${namespace}.nixos.desktop.gaming = {
    enable =
      lib.mkEnableOption "enable gaming related packages and services"
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
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [
      "ntsync"
    ];

    hardware.xone.enable = true;

    programs = {
      gamemode = {
        enable = true;
        settings.general.inhibit_screensaver = 0;
      }; # for performance mode

      steam = {
        enable = true; # install steam

        gamescopeSession.enable = true;
      };
    };

    services = {
      solaar = {
        enable = true; # Enable the service
        package = pkgs.solaar; # The package to use

        window = "only"; # Show the window on startup (show, *hide*, only [window only])
        batteryIcons = "regular"; # Which battery icons to use (*regular*, symbolic, solaar)
        extraArgs = ""; # Extra arguments to pass to solaar on startup
      };
    };

    hardware = {
      new-lg4ff.enable = true;
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

    environment.systemPackages = with pkgs; let
      gamePkgs = inputs.nix-gaming.packages.${system};
    in
      [
        inputs.freesmlauncher.packages.${system}.freesmlauncher
        lutris # install lutris launcher
        winetricks
        vkd3d-proton
        dxvk

        # veloren
        # mindustry-wayland
        # shattered-pixel-dungeon
        (gamePkgs.osu-stable.override {
          useGameMode = false;
        })
        # osu-lazer-bin

        logiops
      ]
      ++ lib.optionals cfg.wine.enable [cfg.wine.package];
  };
}
