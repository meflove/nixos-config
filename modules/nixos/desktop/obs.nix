{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.desktop.obs;
in {
  options.${namespace}.nixos.desktop.obs = {
    enable =
      lib.mkEnableOption "enable OBS Studio with GPU acceleration and useful plugins"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      handbrake # for compressing videos
      v4l-utils
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
  };
}
