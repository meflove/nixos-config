{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pwvucontrol
    vlc
  ];

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-gstreamer
    ];
  };

}
