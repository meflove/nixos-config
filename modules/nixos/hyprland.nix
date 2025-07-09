{ config, pkgs, ... }:
{
  # Включение Wayland и Hyprland
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true; # Важно для совместимости с X11 приложениями [14]
  };

  # Необходимые компоненты для Hyprland [14]
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # xdg-desktop-portal-hyprland для интеграции с приложениями [14]
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Шрифты (пример) [14]
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    nerd-fonts.jetbrains-mono
  ];

  # Dconf для некоторых приложений [14]
  programs.dconf.enable = true;
}
