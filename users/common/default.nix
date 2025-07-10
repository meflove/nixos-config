{ config, pkgs, inputs, ... }:
{
  # Импорт всех модулей Home Manager
  imports = [
    # Импорт всех модулей Home Manager
  imports = [
    inputs.self.modules.home-manager.fish
    inputs.self.modules.home-manager.ghostty
    inputs.self.modules.home-manager.hyprland
    inputs.self.modules.home-manager.programs # Импортируем новый модуль
  ];
    inputs.self.modules.home-manager.programs # Импортируем новый модуль
  ];

  # Общие настройки Home Manager
  home = {
    username = "angeldust";
    homeDirectory = "/home/angeldust";

    packages = with pkgs; [
      htop
      fastfetch
    ];
  };

  # Настройки для XDG Base Directory Specification
  xdg.enable = true;
  xdg.configFile."mimeapps.list".source = "${config.xdg.configHome}/mimeapps.list";

  # Установите версию Home Manager.
  home.stateVersion = "25.05";
}