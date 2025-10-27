{
  pkgs,
  inputs,
  config,
  namespace,
  lib,
  system,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.hyprland;

  rules = import ./rules.nix;
  binds = import ./binds.nix {inherit lib pkgs inputs;};
in {
  options.${namespace}.home.desktop.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland as the window manager." // {default = true;};

    hyprlock.enable = lib.mkEnableOption "Enable hyprlock as the screen locker." // {default = true;};

    hyprpanel.enable = lib.mkEnableOption "Enable hyprpanel as the panel." // {default = true;};
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        libnotify
        swww
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
      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

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
        (import ./settings.nix {inherit pkgs;})
        // {
          bind = binds;
          bindm = [
            "Super, mouse:272, movewindow"
            "Super, mouse:273, resizewindow"
          ];

          windowrule = rules.windowRules;
          layerrule = rules.layerRules;
        };

      extraConfig = ''
        exec-once = clipse -listen
        exec-once = easyeffects --gapplication-service &
        exec-once = hyprpanel &> /dev/null
        exec-once = hyprlock

        exec-once = [workspace 1 silent] AyuGram
        exec-once = [workspace 2 silent] zen
      '';
    };
  };
}
