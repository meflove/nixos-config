{
  pkgs,
  inputs,
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.desktop.hyprland;

  settings = import ./settings.nix {inherit pkgs;};
  rules = import ./rules.nix;
  binds = import ./binds.nix {inherit config lib pkgs inputs;};
in {
  options.home.${namespace}.desktop.hyprland = {
    enable =
      lib.mkEnableOption ''
        Enable Hyprland as the Wayland compositor/window manager.

        Configures Hyprland with:
        - Dynamic tiling with keyboard-driven workflow
        - Custom animations and visual effects
        - Multi-monitor support with proper workspaces
        - Integration with Hyprpanel and Hyprlock
        - Gaming optimizations (VRR, tearing controls)
        - Extensive keybindings for window management
      ''
      // {default = true;};

    hyprlock.enable =
      lib.mkEnableOption ''
        Enable Hyprlock as the screen locker.

        Provides modern Wayland screen locking with:
        - Customizable lock screen with time/date display
        - Password authentication support
        - Smooth animations and blur effects
        - Integration with Hyprland system theme
      ''
      // {default = true;};

    hyprpanel.enable =
      lib.mkEnableOption ''
        Enable Hyprpanel as the system panel/bar.

        Feature-rich panel including:
        - System tray and notification center
        - Workspace overview and window switcher
        - System controls (volume, brightness, network)
        - Customizable widgets and themes
        - Quick settings and application menu
      ''
      // {default = false;};

    autologin.enable = lib.mkEnableOption ''Enable automatic login for a specified user.'' // {default = false;};
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        libnotify
        swww
        hyprpolkitagent
      ];

      sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        WLR_NO_HARDWARE_CURSORS = "1";

        XDG_SESSION_TYPE = "wayland";
        WLR_RENDERER = "vulkan";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        NIXOS_OZONE_WL = "1";
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      systemd = {
        enable = true;

        variables = [
          "--all"
          "DISPLAY"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
        ];

        enableXdgAutostart = true;
      };

      xwayland.enable = true;

      settings =
        settings
        // {
          exec-once = [
            "systemctl --user start hyprpolkitagent"
            "dms run &"
            "${lib.getExe pkgs.clipse} -listen"
            "${lib.getExe pkgs.easyeffects} --gapplication-service &"

            "[workspace 1 silent] AyuGram"
            "[workspace 2 silent] zen"
            "[workspace special silent] soundcloud-desktop"
          ];

          bind = binds;
          bindm = [
            "Super, mouse:272, movewindow"
            "Super, mouse:273, resizewindow"
          ];

          windowrule = rules.windowRules;
          layerrule = rules.layerRules;
        };
    };
  };
}
