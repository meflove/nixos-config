{ config, pkgs, lib, inputs, ... }:

let
  # Список папок в dotfiles/config, которые нужно связать
  configDirs = [
    "ags", "easyeffects", "fastfetch", "fish", "ghostty", "hypr",
    "hyprpanel", "kitty", "nvim", "tmux", "zellij"
  ];

  # Автоматически создаем атрибуты для xdg.configFile
  configLinks = lib.listToAttrs (map (dir: {
    name = dir;
    value = {
      source = ../../dotfiles/config/${dir};
      recursive = true;
    };
  }) configDirs);

in
{
  # Импортируем модули, чтобы программы были установлены и активированы
  imports = [
    inputs.self.modules.home-manager.fish
    inputs.self.modules.home-manager.ghostty
    inputs.self.modules.home-manager.hyprland
    inputs.self.modules.home-manager.programs
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