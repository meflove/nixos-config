{
  programs.easyeffects.enable = true;

  home.file."${xdg.configHome}/easyeffects" = {
    source = ../../dotfiles/easyeffects;
    recursive = true;
  };
}
