{pkgs, ...}: {
  home.packages = with pkgs; [
    pwvucontrol
    vlc
  ];

  programs.obs-studio = {
    enable = false;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-gstreamer
      obs-pipewire-audio-capture
      droidcam-obs
    ];
  };
}
