{
  programs.fastfetch.enable = true;

  home.file."${xdg.configHome}/easyeffects" = {
    source = ../../dotfiles/fastfetch;
    recursive = true;
  };
}


