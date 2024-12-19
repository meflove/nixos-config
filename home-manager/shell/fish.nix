{ config, ... }:

{
  programs.fish.enable = true;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_DIRS = "/etc/xdg";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_DIRS = "/usr/local/share/:/usr/share/";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  home.file."${config.xdg.configHome}/fish" = {
    source = ../../dotfiles/fish;
    recursive = true;
  };
}
