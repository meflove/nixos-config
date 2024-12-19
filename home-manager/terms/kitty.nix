{
  programs.kitty.enable = true;

  home.file."${config.xdg.configHome}/kitty" = {
    source = ../../dotfiles/kitty;
    recursive = true;
  };
}
