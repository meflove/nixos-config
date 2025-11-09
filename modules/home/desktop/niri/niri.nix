{
  pkgs,
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.niri;

  binds = import ./binds.nix {inherit pkgs lib;};
in {
  options.${namespace}.home.desktop.niri = {
    enable =
      lib.mkEnableOption ''
        enable niri
      ''
      // {default = true;};

    autologin.enable = lib.mkEnableOption ''Enable automatic login for a specified user. '' // {default = false;};
  };

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;

      settings = {
        inherit binds;

        spawn-at-startup = [
          {
            argv = [
              "${pkgs.dbus}/bin/dbus-update-activation-environment"
              "--systemd"
              "--all"
              "DISPLAY"
              "WAYLAND_DISPLAY"
              "XDG_CURRENT_DESKTOP"
              "NIRI_SOCKET"
            ];
          }
        ];

        outputs = {
          "DP-1" = {
            mode = {
              width = 2560;
              height = 1440;
              refresh = 143.97200;
            };
            scale = 1;
            position = {
              x = 1920;
              y = 0;
            };
            variable-refresh-rate = false;
            focus-at-startup = true;
          };
          "HDMI-A-1" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 60.0;
            };
            scale = 1;
            position = {
              x = 0;
              y = 360;
            };
          };
        };
      };
    };
  };
}
