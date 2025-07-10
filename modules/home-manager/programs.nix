{ config, pkgs, ... }:
{
  # Настройка Git
  programs.git = {
    enable = true;
    userName = "meflove";
    userEmail = "meflov3r@gmail.com";
  };

  # Настройка GnuPG
  programs.gnupg.enable = true;

  # Настройка SSH
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    "github.com" = {
      user = "git";
      identityFile = "~/.ssh/id_ed25519";
    };
  };
}
