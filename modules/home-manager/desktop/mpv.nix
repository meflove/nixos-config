{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv-unwrapped.wrapper {
      mpv = pkgs.mpv-unwrapped;
      youtubeSupport = true;
    };

    config = {
      profile = "gpu-hq";
      ytdl-format = "bestvideo+bestaudio";
      # cache-default = 4000000;
    };
  };
}
