{ pkgs, ... }:
{

  home.packages = with pkgs; [ aria2 ];

  programs.git = {
    enable = true;
    userName = "meflove";
    userEmail = "meflov3r@icloud.com";
  };

  # Настройка GnuPG
  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  # Настройка SSH

  programs.ssh = {
    enable = true;

    enableDefaultConfig = true;
    matchBlocks = {
      "github.com" = {
        user = "angeldust";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  programs.yt-dlp = {
    enable = true;

    settings = {
      embed-thumbnail = true;
      embed-subs = true;
      sub-langs = "all";
      downloader = "aria2c";
      downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
    };
  };
}
