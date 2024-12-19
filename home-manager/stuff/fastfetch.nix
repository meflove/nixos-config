{ config, ... }:

{
  programs.fastfetch.enable = true;

  home.file."${config.xdg.configHome}/easyeffects" = {
    source = ../../dotfiles/fastfetch;
    recursive = true;
  };
}


