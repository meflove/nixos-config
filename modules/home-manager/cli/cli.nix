{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dust
    duf
    progress
    viddy
    kalker
    python313Packages.downloader-cli
    blobdrop
    grc
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/angeldust/.config/nixos-config"; # sets NH_OS_FLAKE variable for you
    osFlake = "/home/angeldust/.config/nixos-config";
    homeFlake = "/home/angeldust/.config/nixos-config";
  };

  services.clipse = {
    enable = true;

    historySize = 1000;
    imageDisplay.type = "kitty";
  };
}
