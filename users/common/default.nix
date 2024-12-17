{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
    ../../modules/home-manager/fish.nix
    ../../modules/home-manager/ghostty.nix
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/programs.nix
    ../../modules/home-manager/atuin.nix
    ../../modules/home-manager/zen.nix
  ];


  # Общие настройки Home Manager
  home = {
    username = "angeldust";
    # homeDirectory = "/home/angeldust";
    stateVersion = "25.05";

    # Устанавливаем программы, у которых нет специальных модулей
    # или чьи модули мы не используем для конфигурации
    packages = with pkgs; [
      htop
      fastfetch
      kitty
      neovim
      tmux
      zellij
      easyeffects
      grc
      xdg-user-dirs
      yazi
      dust
      duf
      # hyprpanel - может быть частью hyprland или отдельным пакетом
    ];

  };

  # Настройки для XDG Base Directory Specification
  xdg = {
    enable = true;
  };
}

