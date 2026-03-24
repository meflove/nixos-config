{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  colors = import ./colors.nix {inherit pkgs lib;};
in {
  screenshot-path = null;

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

  binds = import ./binds.nix {
    inherit
      pkgs
      lib
      config
      inputs
      ;
  };

  input = {
    keyboard = {
      xkb = {
        layout = "us,ru";
        options = "grp:caps_toggle";
      };
      numlock = true;
      repeat-delay = 250;
      repeat-rate = 35;
    };

    mouse = {
      scroll-method = "no-scroll";
      accel-profile = "adaptive";
    };

    trackpoint = {
      scroll-method = "on-button-down";
      accel-profile = "flat";
    };

    power-key-handling.enable = false;
    focus-follows-mouse.enable = true;
    workspace-auto-back-and-forth = false;
  };

  layout = {
    background-color = colors.base00;

    border = let
      mk = from: to: {
        gradient = {
          inherit from to;
          relative-to = "workspace-view";
          angle = 45;
        };
      };
    in {
      enable = true;
      width = 1;

      active = mk colors.mauve colors.rosewater;
      inactive.color = colors.base00;

      # urgent = mk colors.base08 colors.base09;
      urgent = mk colors.mauve colors.rosewater;
    };
    # // (
    #   if false
    #   then {
    #     active = mk colors.base0B colors.base0A;
    #     inactive.color = colors.base00;
    #     urgent = mk colors.base08 colors.base09;
    #   }
    #   else {
    #     active.color = colors.mauve;
    #     inactive.color = "#595959aa";
    #     urgent.color = colors.base08;
    #   }
    # );

    insert-hint = {
      display.color = colors.base01 + "CC";
    };

    gaps = 10;

    struts = lib.genAttrs [
      "left"
      "right"
      "top"
      "bottom"
    ] (_: 12);

    shadow = {
      enable = true;
      softness = 30;
      draw-behind-window = true;
      color = colors.base00 + "70";
      inactive-color = colors.base00 + "70";
    };

    default-column-width = {
      proportion = 0.5;
    };

    preset-column-widths = [
      {proportion = 0.5;}
      {proportion = 0.6;}
      {proportion = 0.7;}
      {proportion = 1.0;}
    ];

    center-focused-column = "never";
    always-center-single-column = true;
  };

  animations =
    (
      lib.genAttrs
      [
        "horizontal-view-movement"
        "window-movement"
        "window-resize"
      ]
      (_: {
        kind.spring = {
          damping-ratio = 0.760000;
          epsilon = 0.000100;
          stiffness = 700;
        };
      })
    )
    // (
      lib.genAttrs
      [
        "window-close"
        "window-open"
        "workspace-switch"
      ]
      (_: {
        kind.easing = {
          duration-ms = 150;
          curve = "ease-out-expo";
        };
      })
    );

  window-rules =
    [
      {
        clip-to-geometry = true;
        geometry-corner-radius = lib.genAttrs [
          "top-left"
          "top-right"
          "bottom-left"
          "bottom-right"
        ] (_: 12.0);
      }
    ]
    ++ import ./rules.nix {
      inherit
        lib
        config
        pkgs
        ;
    };

  layer-rules = [
    {
      block-out-from = "screencast";
      matches = [
        {
          namespace = "^notifications$";
        }
      ];
    }
  ];

  workspaces = let
    mkWorkspace = monitor: {
      open-on-output = monitor;
    };
  in {
    "telegram" = mkWorkspace "HDMI-A-1";
    "browser" = mkWorkspace "DP-1";
    "cli" = mkWorkspace "DP-1";
    "games" = mkWorkspace "DP-1";
  };

  overview = {
    zoom = 0.95;
    backdrop-color = colors.base00;
    workspace-shadow = {
      softness = 20;
      spread = 14;
      color = colors.base00;
    };
  };

  # clipboard.disable-primary = true;
  gestures.hot-corners.enable = false;
  hotkey-overlay.skip-at-startup = true;
  prefer-no-csd = true;

  environment = {
    DISPLAY = ":0";
    SLURP_ARGS = "-b ${colors.base00}CC -c ${colors.base0F}FF -B ${colors.base02}CC";
  };

  debug.deactivate-unfocused-windows = false;

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

  xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
}
