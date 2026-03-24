{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      inputs,
      ...
    }: {
      environment = {
        etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text = ''
          {
            "rules": [
              {
                "pattern": {
                  "feature": "procname",
                  "matches": "niri"
                },
                "profile": "Limit Free Buffer Pool On Wayland Compositors"
              }
            ],
            "profiles": [
              {
                "name": "Limit Free Buffer Pool On Wayland Compositors",
                "settings": [
                  {
                    "key": "GLVidHeapReuseRatio",
                    "value": 0
                  }
                ]
              }
            ]
          }
        '';

        systemPackages = with pkgs; [xdg-utils];
      };
      programs = {
        xwayland.enable = true;
        niri = {
          enable = true;
          package = pkgs.niri-unstable;
          useNautilus = false;
        };
      };

      security = {
        polkit.enable = true;
        pam.services.swaylock = {};
      };

      hm = {
        home = {
          sessionVariables = {
            QT_QPA_PLATFORM = "wayland";
            WLR_NO_HARDWARE_CURSORS = "1";

            XDG_SESSION_TYPE = "wayland";
            WLR_RENDERER = "vulkan";
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
            NIXOS_OZONE_WL = "1";
          };
        };

        programs.niri = let
          settings = import ./settings.nix {
            inherit pkgs lib config inputs;
          };
        in {
          inherit (config.programs.niri) package enable;

          inherit settings;
        };

        # XDG portal configuration
        xdg.portal = {
          config.niri = {
            default = ["gtk" "gnome"];
          };

          extraPortals = [
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-gtk
          ];
        };

        systemd.user.services.stylix-bg-niri = {
          Unit = {
            Description = "Sets stylix image as background for niri";
            After = ["niri.service"];
          };

          Service = {
            ExecStart = lib.concatStringsSep " " [
              (lib.getExe pkgs.swww)
              "img"
              lib.stylix.image
            ];

            Type = "simple";
            KillMode = "process";
            Restart = "on-failure";
            RestartSec = 5;
          };

          Install.WantedBy = ["graphical-session.target"];
        };
      };
    };
  };
}
