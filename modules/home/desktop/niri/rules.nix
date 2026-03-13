{lib, ...}: let
  corner = rounding:
    lib.genAttrs [
      "top-left"
      "top-right"
      "bottom-left"
      "bottom-right"
    ] (_: rounding);

  # size = height: width: {
  #   default-column-width.fixed = width;
  #   default-window-height.fixed = height;
  # };

  makeFloatingWindowRule = app-id: width: height: {
    open-floating = true;
    geometry-corner-radius = corner 12.0;
    default-column-width.fixed = width;
    default-window-height.fixed = height;
    matches = [
      {
        app-id = "^${app-id}$";
      }
    ];
  };
in
  [
    # Floating window rules
    (makeFloatingWindowRule "com.free.clipse" 900 650)
    (makeFloatingWindowRule "com.free.otter-launcher" 600 500)
    (makeFloatingWindowRule "com.free.fsel" 600 500)
    (makeFloatingWindowRule "com.free.kalker" 600 500)
    (makeFloatingWindowRule "com.free.bluetui" 900 750)
  ]
  ++ [
    # Blobdrop
    {
      open-floating = true;
      matches = [
        {
          title = "^Blobdrop$";
        }
      ];
    }

    {
      draw-border-with-background = false;
      matches = [
        {
          app-id = "^zen-twilight$";
        }
      ];
    }

    # Picture-in-Picture
    {
      open-floating = true;
      default-floating-position = {
        x = 20;
        y = 23;

        relative-to = "bottom-right";
      };
      matches = [
        {
          app-id = "^zen";
          title = "^Picture-in-Picture$";
        }
      ];
    }

    # Fullscreen apps
    {
      open-fullscreen = true;
      matches = [
        {
          app-id = "^steam_app.*$";
        }
        {
          app-id = "^swayimg$";
        }
        {
          app-id = "ayugram";
          title = "^Media";
        }
      ];
    }

    # Steam notifications
    {
      open-focused = false;
      clip-to-geometry = true;
      geometry-corner-radius = corner 4.0;
      default-floating-position = {
        x = -10;
        y = -10;
        relative-to = "bottom-right";
      };
      matches = [
        {
          app-id = "^steam$";
          title = ''^notificationtoasts_\d+_desktop$'';
        }
      ];
    }

    {
      open-maximized = false;
      open-fullscreen = false;
    }
  ]
