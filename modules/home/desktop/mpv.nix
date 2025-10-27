{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.mpv;
in {
  options.${namespace}.home.desktop.mpv = {
    enable =
      lib.mkEnableOption "enable mpv media player with youtube-dl support"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      package = pkgs.mpv-unwrapped.wrapper {
        mpv = pkgs.mpv-unwrapped;
        youtubeSupport = true;
      };

      config = {
        profile = "gpu-hq";
        ytdl-format = "bestvideo+bestaudio";
      };
    };
  };
}
