{ config, pkgs, lib, inputs, ... }:

let
  # Список папок в dotfiles/config, которые нужно связать
  configDirs = [
    "easyeffects"
    "fastfetch"
    "fish"
    "ghostty"
    "hypr"
    "hyprpanel"
    "kitty"
    "nvim"
    "tmux"
    "zellij"
  ];

  # Автоматически создаем атрибуты для xdg.configFile
  configLinks = lib.listToAttrs (map
    (dir: {
      name = dir;
      value = {
        source = ../../dotfiles/config/${dir};
        recursive = true;
      };
    })
    configDirs);

in
{
  imports = [
    ../../modules/home-manager/fish.nix
    ../../modules/home-manager/ghostty.nix
    ../../modules/home-manager/hyprland.nix
    ../../modules/home-manager/programs.nix
    ../../modules/home-manager/atuin.nix
  ];

  # Общие настройки Home Manager
  home = {
    username = "angeldust";
    homeDirectory = "/home/angeldust";
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
      ags # Предполагая, что пакет называется 'ags'
      easyeffects
      # hyprpanel - может быть частью hyprland или отдельным пакетом
    ];
  };

  # Настройки для XDG Base Directory Specification
  xdg = {
    enable = true;
    # Управляем конфигурациями через символические ссылки на папки
    configFile = configLinks;
  };
}

