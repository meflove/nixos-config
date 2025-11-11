{
  pkgs,
  lib,
  ...
}: let
  binds = import ./binds.nix {inherit lib pkgs;};
in {
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

  overview = {
    workspace-shadow.enable = false;
    backdrop-color = "transparent";
  };

  input = {
    keyboard = {
      numlock = true;
      repeat-delay = 250;
      repeat-rate = 35;
      xkb = {
        layout = "us,ru";
        options = "grp:caps_toggle,grp:alt_shift_toggle";
      };
    };
  };

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
}
