{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    handbrake # for compressing videos
  ];

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
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
