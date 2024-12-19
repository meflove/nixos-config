{
  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];

  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # config
  home.file."${config.xdg.configHome}/hypr" = {
    source = ../../../dotfiles/hypr;
    recursive = true;
  };
}
