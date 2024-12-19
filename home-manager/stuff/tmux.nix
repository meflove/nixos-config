{ config, ... }:

{
  programs.tmux.enable = true;

  home.file."${config.xdg.configHome}/tmux" = {
    source = ../../dotfiles/tmux;
    recursive = true;
  };
}
