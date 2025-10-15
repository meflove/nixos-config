{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    handbrake # for compressing videos
  ];

  security.polkit.enable = true;

  programs.obs-studio = {
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
}
