{config, ...}: {
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

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber = {
        enable = true;
      };

      extraConfig = {
        pipewire = {
          "20-no-resampling" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.allowed-rates" = [
                44100
                48000
                96000
                192000
              ];
            };
          };

          "10-sound" = {
            "context.properties" = {
              "default.clock.min-quantum" = 512;
              "default.clock.quantum" = 4096;
              "default.clock.max-quantum" = 8192;
            };
          };
        };

        pipewire-pulse."20-upmix" = {
          # Enables upmixing
          "stream.properties" = {
            "channelmix.upmix" = true;
            "channelmix.upmix-method" = "psd"; # none, simple
            "channelmix.lfe-cutoff" = 150;
            "channelmix.fc-cutoff" = 12000;
            "channelmix.rear-delay" = 12.0;
          };
        };

        client."20-upmix" = config.services.pipewire.extraConfig.pipewire-pulse."20-upmix";
      };
    };
  };
}
