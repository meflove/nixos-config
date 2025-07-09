{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland.enable = true;

  # Настройки Hyprland через Home Manager
  # Предпочтительно использовать опции Home Manager, если они доступны
  # для декларативной настройки. Если опций нет, можно использовать home.file
  # для создания hyprland.conf вручную.[14]
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind = [
      "$mod, T, exec, ghostty" # Пример: запуск терминала
      "$mod, Q, killactive,"
      "$mod, E, exec, dolphin" # Пример: запуск файлового менеджера
      #... другие привязки клавиш
    ];
    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };
      shadow = {
        enable = true;
        offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };
    };
    #... другие настройки Hyprland
  };

  # Пример добавления плагина Hyprland через flake input [14]
  # wayland.windowManager.hyprland.plugins = [
  #   inputs.plugin_name.packages.${pkgs.system}.default
  # ];
}
