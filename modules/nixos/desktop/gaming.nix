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
      lib.mkEnableOption ''
        Enable comprehensive gaming environment with performance optimizations.

        This module configures a complete gaming setup including:
        - Steam with Gamescope integration for improved gaming experience
        - GameMode for CPU/GPU optimization during gaming
        - ntsync kernel module for improved Windows game compatibility
        - Solaar for Logitech gaming device management
        - Wine/Proton integration through home-manager modules

        Designed for both native Linux gaming and Windows compatibility.
      ''
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    # Assertions to validate gaming configuration
    assertions = [
      {
        assertion = config.hardware.graphics.enable;
        message = "Gaming module requires graphics acceleration to be enabled via hardware.graphics.enable.";
      }
      {
        assertion = config.${namespace}.nixos.hardware.nvidia.enable;
        message = "Gaming module requires NVIDIA drivers to be enabled for optimal performance.";
      }
    ];

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
        package = pkgs.steam;

        gamescopeSession.enable = true;
      };
    };

    services = {
      solaar = {
        enable = true; # Enable the service
        package = pkgs.solaar; # The package to use

        window = "hide"; # Show the window on startup (show, *hide*, only [window only])
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
      logiops
    ];
  };
}
