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

  home.file."/home/meflove/.config/ags" = {
    source = "../../dotfiles/config/ags";
    recursive = true;
  };

  # home.file."${config.xdg.configHome}" = {
  #   source = ../../dotfiles/config/starship.toml;
  #   recursive = true;
  # };
}
