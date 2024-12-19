{
  programs.tmux.enable = true;

  home.file."${xdg.configHome}/tmux" = {
    source = ../../dotfiles/tmux;
    recursive = true;
  };
}
