{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.hardware.sound;
in {
  options.${namespace}.nixos.hardware.sound = {
    enable =
      lib.mkEnableOption "enable PipeWire for audio handling"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      uxplay
    ];

    security = {
      rtkit.enable = true;

      pam.loginLimits = [
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "98";
        }
      ];
    };

    services = {
      pulseaudio.enable = false;
      avahi = {
        enable = true;
        nssmdns4 = true;
        nssmdns6 = true;
        publish = {
          enable = true;
          userServices = true;
          workstation = true;
        };
      };

      pipewire = let
        defaultRate = 48000;
        quantum = 512;
        qr = "${toString quantum}/${toString defaultRate}";
      in {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        raopOpenFirewall = true;

        wireplumber = {
          enable = true;
          extraConfig = mkIf config.services.pipewire.alsa.enable {
            "99-alsa-lowlatency"."monitor.alsa.rules" = [
              {
                matches = [{"node.name" = "~alsa_output.*";}];
                actions.update-props = {
                  "audio.format" = "S32LE";
                  "audio.rate" = defaultRate;
                };
              }
            ];
          };
        };

        extraConfig = let
          upmixConfig = {
            # Enables upmixing
            "stream.properties" = {
              "channelmix.upmix" = true;
              "channelmix.upmix-method" = "psd"; # none, simple
              "channelmix.lfe-cutoff" = 150;
              "channelmix.fc-cutoff" = 12000;
              "channelmix.rear-delay" = 12.0;
            };
          };
        in {
          pipewire = {
            "10-sound" = {
              "context.properties" = {
                "default.clock.min-quantum" = quantum;
                "default.clock.quantum" = 4096;
                "default.clock.max-quantum" = 8192;
                "default.clock.rate" = defaultRate;
                "default.clock.allowed-rates" = [
                  44100
                  48000
                  96000
                  192000
                ];
              };

              "context.modules" = [
                {
                  name = "libpipewire-module-rt";
                  flags = [
                    "ifexists"
                    "nofail"
                  ];
                  args = {
                    "nice.level" = -15;
                    "rt.prio" = 88;
                    "rt.time.soft" = 200000;
                    "rt.time.hard" = 200000;
                  };
                }
              ];
            };

            "10-airplay" = {
              "context.modules" = [
                {
                  name = "libpipewire-module-raop-discover";

                  # increase the buffer size if you get dropouts/glitches
                  args = {
                    "raop.latency.ms" = 500;
                  };
                }
              ];
            };
          };

          pipewire-pulse."20-upmix" = upmixConfig;

          pipewire-pulse."99-lowlatency" = {
            "pulse.properties" = {
              "server.address" = ["unix:native"];
              "pulse.min.req" = qr;
              "pulse.min.quantum" = qr;
              "pulse.min.frag" = qr;
            };
          };

          client."20-upmix" = upmixConfig;

          client."99-lowlatency" = {
            "stream.properties" = {
              "node.latency" = qr;
              "resample.quality" = 1;
            };
          };
        };
      };
    };
  };
}
