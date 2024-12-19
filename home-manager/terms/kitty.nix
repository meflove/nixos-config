{
  programs.kitty.enable = true;

  home.file."${xdg.configHome}/kitty" = {
    source = ../../dotfiles/kitty;
    recursive = true;
  };
}
