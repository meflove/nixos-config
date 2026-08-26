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
        etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
          lib.toJSON
          {
            rules = [
              {
                pattern = {
                  feature = "procname";
                  matches = "niri";
                };
                profile = "Limit Free Buffer Pool On Wayland Compositors";
              }
            ];
            profiles = [
              {
                name = "Limit Free Buffer Pool On Wayland Compositors";
                settings = [
                  {
                    key = "GLVidHeapReuseRatio";
                    value = 0;
                  }
                ];
              }
            ];
          };

        systemPackages = lib.attrValues {
          inherit
            (pkgs)
            xdg-utils
            ;
        };
      };
      programs = {
        xwayland.enable = true;
        niri = {
          enable = true;
          package = pkgs.niri-unstable;
          useNautilus = true;
        };
      };

      security = {
        polkit.enable = true;
      };

      hm = {
        home = {
          sessionVariables = {
            QT_QPA_PLATFORM = "wayland";
            WLR_NO_HARDWARE_CURSORS = "1";

            XDG_SESSION_TYPE = "wayland";
            GDK_BACKEND = "wayland";
            WLR_RENDERER = "vulkan";
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
            NIXOS_OZONE_WL = "1";
          };
        };

        services.swayidle = let
          niri = lib.getExe config.hm.programs.niri.package;
          lock = "${lib.getExe config.hm.programs.hyprlock.package} --grace 0";

          display = status: "${niri} msg action power-${status}-monitors";
        in {
          enable = true;

          extraArgs = [
            "-d"
          ];

          timeouts = [
            {
              timeout = 9 * 60; # in seconds
              command = "${pkgs.libnotify}/bin/notify-send -i dialog-information -u normal 'LOCK' 'Locking in 1 minute' -t 60000";
            }
            {
              timeout = 10 * 60;
              command = lock;
            }
            {
              timeout = 15 * 60;
              command = display "off";
              resumeCommand = display "on";
            }
          ];

          events = {
            before-sleep = (display "off") + "; " + lock;
            after-resume = display "on";
            lock = (display "off") + "; " + lock;
            unlock = display "on";
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

        systemd.user.services.stylix-bg-niri = {
          Unit = {
            Description = "Sets stylix image as background for niri";
            After = ["niri.service"];
          };

          Service = {
            ExecStart = lib.concatStringsSep " " [
              (lib.getExe pkgs.awww)
              "img"
              config.stylix.image
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
