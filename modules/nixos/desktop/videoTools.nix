{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.desktop.videoTools;
in {
  options.${namespace}.nixos.desktop.videoTools = {
    enable =
      lib.mkEnableOption "enable GPU-accelerated video tools such as OBS Studio and HandBrake"
      // {
        default = false;
      };

    obs.enable =
      lib.mkEnableOption "enable OBS Studio virtual camera support"
      // {
        default = false;
      };

    gpuScreenRecorder.enable =
      lib.mkEnableOption "enable GPU Screen Recorder GTK GUI application"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        handbrake # for compressing videos
        v4l-utils
        ffmpeg
      ]
      ++ lib.optional cfg.gpuScreenRecorder.enable gpu-screen-recorder-gtk;

    programs = {
      gpu-screen-recorder.enable = cfg.gpuScreenRecorder.enable; # For promptless recording on both CLI and GUI

      obs-studio = {
        inherit (cfg.obs) enable;

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
  };
}
