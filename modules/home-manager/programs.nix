{ config, pkgs, ... }:
{
  # Настройка Git
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
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    "github.com" = {
      user = "git";
      identityFile = "~/.ssh/id_ed25519";
    };
  };

}
