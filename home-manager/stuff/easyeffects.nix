{
  programs.easyeffects.enable = true;

  home.file."${config.xdg.configHome}/easyeffects" = {
    source = ../../dotfiles/easyeffects;
    recursive = true;
  };
}
