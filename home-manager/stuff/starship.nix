{
  programs.starship.enable = true;

  home.file."${xdg.configHome}/starship" = {
    source = ../../dotfiles/fastfetch;
    recursive = true;
  };
}
