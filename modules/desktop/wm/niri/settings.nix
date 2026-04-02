{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
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

  cursor = {
    theme = config.stylix.cursor.name;
    size = config.stylix.cursor.size;
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

    power-key-handling.enable = false;
    focus-follows-mouse.enable = true;
    workspace-auto-back-and-forth = false;
  };

  layout = {
    background-color = config.lib.stylix.colors.withHashtag.base00;

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

      active = mk config.lib.stylix.colors.withHashtag.magenta config.lib.stylix.colors.withHashtag.brown;
      inactive.color = config.lib.stylix.colors.withHashtag.base00;

      # urgent = mk config.lib.stylix.colors.withHashtag.base08 config.lib.stylix.colors.withHashtag.base09;
      urgent = mk config.lib.stylix.colors.withHashtag.magenta config.lib.stylix.colors.withHashtag.brown;
    };

    insert-hint = {
      display.color = config.lib.stylix.colors.withHashtag.base01 + "CC";
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
      color = config.lib.stylix.colors.withHashtag.base00 + "70";
      inactive-color = config.lib.stylix.colors.withHashtag.base00 + "70";
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
    backdrop-color = config.lib.stylix.colors.withHashtag.base00;
    workspace-shadow = {
      softness = 20;
      spread = 14;
      color = config.lib.stylix.colors.withHashtag.base00;
    };
  };

  # clipboard.disable-primary = true;
  gestures.hot-corners.enable = false;
  hotkey-overlay.skip-at-startup = true;
  prefer-no-csd = true;

  environment = {
    SLURP_ARGS = "-b ${config.lib.stylix.colors.withHashtag.base00}CC -c ${config.lib.stylix.colors.withHashtag.base0F}FF -B ${config.lib.stylix.colors.withHashtag.base02}CC";
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
    {
      argv = [
        (lib.getExe config.hm.programs.zen-browser.package)
      ];
    }
    {
      argv = [
        (lib.getExe inputs.self.packages.${lib.hostPlatform}.soundcloud-desktop)
      ];
    }
    {
      argv = [
        (lib.getExe inputs.ayugram-desktop.packages.${lib.hostPlatform}.default)
      ];
    }
  ];

  xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
}
