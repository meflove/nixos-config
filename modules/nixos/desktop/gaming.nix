{
  pkgs,
  lib,
  config,
  namespace,
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
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [
      "ntsync"
    ];

    programs = {
      gamemode = {
        enable = true;

        settings.general.inhibit_screensaver = 0;
      }; # for performance mode

      steam = {
        enable = true; # install steam
        package = pkgs.unstable.steam;

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
      xone.enable = true;
      new-lg4ff.enable = true;
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      vkd3d-proton
      dxvk

      logiops
    ];
  };
}
