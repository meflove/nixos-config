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
  };
}
