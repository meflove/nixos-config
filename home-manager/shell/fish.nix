{ config, ... }:

{
  programs.fish.enable = true;

  home.file."${config.xdg.configHome}/fish" = {
    source = ../../dotfiles/fish;
    recursive = true;
  };
}
