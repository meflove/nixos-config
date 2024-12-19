{ config, pkgs, ... }:

{
  programs.ags = {
    enable = true;

  # additional packages to add to gjs's runtime
  extraPackages = with pkgs; [
    gtksourceview
    webkitgtk
    accountsservice
  ];
  };

  home.file."${config.xdg.configHome}/ags" = {
    source = ../../dotfiles/ags;
    recursive = true;
  };
}
