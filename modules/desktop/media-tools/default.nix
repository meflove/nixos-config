{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      # lib,
      # inputs,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        # handbrake # for compressing videos
        v4l-utils
        ffmpeg
        gpu-screen-recorder-gtk
        imv # Image viewer for Wayland
        gimp
        vlc
        # inputs.jonhermansen-nur-packages.packages.${lib.hostPlatform}.davinci-resolve-studio
      ];

      programs = {
        gpu-screen-recorder.enable = true; # For promptless recording on both CLI and GUI

        obs-studio = {
          enable = true;

          enableVirtualCamera = true;

          plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-vaapi
            obs-vkcapture
            obs-gstreamer
            obs-pipewire-audio-capture
            droidcam-obs
          ];
        };
      };
      hm = {
        programs.mpv = {
          enable = true;
          package = pkgs.mpv.override {
            youtubeSupport = true;
          };

          config = {
            profile = "gpu-hq";
            ytdl-format = "bestvideo+bestaudio";
          };
        };
      };
    };
  };
}
