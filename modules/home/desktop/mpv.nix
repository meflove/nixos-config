{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.desktop.mpv;
in {
  options.home.${namespace}.desktop.mpv = {
    enable =
      lib.mkEnableOption "enable mpv media player with youtube-dl support"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
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
}
