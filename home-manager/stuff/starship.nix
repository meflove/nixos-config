{
  programs.starship.enable = true;

  home.file."${config.xdg.configHome}/starship" = {
    source = ../../dotfiles/fastfetch;
    recursive = true;
  };
}
