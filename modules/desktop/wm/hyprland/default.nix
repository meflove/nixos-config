{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      inputs,
      ...
    }: let
      settings = import ./settings.nix {inherit config;};
      rules = import ./rules.nix;
      binds = import ./binds.nix {inherit config lib pkgs inputs;};
    in {
      programs = {
        dconf.enable = true;

        xwayland.enable = true;
        hyprland = {
          enable = true;
          package = inputs.hyprland.packages.${lib.hostPlatform}.hyprland;
          portalPackage = inputs.hyprland.packages.${lib.hostPlatform}.xdg-desktop-portal-hyprland;
        };
      };

      hm = {
        wayland.windowManager.hyprland = {
          inherit (config.programs.hyprland) enable package portalPackage;

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
                "systemctl --user start hyprland-session.target"
                "systemctl --user start hyprpolkitagent"
                "${lib.getExe pkgs.awww} img ${../../../../pics/lock_screen.png}"

                "[workspace 1 silent] ${lib.getExe inputs.ayugram-desktop.packages.${lib.hostPlatform}.default}"
                "[workspace 2 silent] ${lib.getExe config.programs.zen-browser.package}"
                "[workspace special silent] ${lib.getExe pkgs.angeldust-pkgs.soundcloud-desktop}"
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

        xdg = {
          portal = {
            enable = true;
            extraPortals = lib.attrValues {
              inherit
                (pkgs)
                xdg-desktop-portal-gtk
                xdg-desktop-portal-wlr
                xdg-desktop-portal-gnome
                ;
            };
          };
        };

        home = {
          packages = lib.attrValues {
            inherit
              (pkgs)
              libnotify
              hyppolkitagent
              ;
          };

          sessionVariables = {
            QT_QPA_PLATFORM = "wayland";
            WLR_NO_HARDWARE_CURSORS = "1";

            XDG_SESSION_TYPE = "wayland";
            WLR_RENDERER = "vulkan";
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
            NIXOS_OZONE_WL = "1";
          };
        };
      };
    };
  };
}
