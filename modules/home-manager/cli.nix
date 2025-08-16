{ pkgs, ... }: {
  home.packages = with pkgs; [
    yazi
    dust
    duf
    progress
    viddy
    clipse
    kalker
    python313Packages.downloader-cli
    blobdrop
    grc
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake =
      "/home/angeldust/.config/nixos-config"; # sets NH_OS_FLAKE variable for you
  };
}
