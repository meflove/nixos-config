{ config, pkgs, lib, inputs, ... }:

let
  # Путь к вашим dotfiles
  dotfilesDir = ../../dotfiles;

  # Функция для рекурсивного поиска файлов и создания атрибутов
  mapDirectory = dir:
    let
      items = builtins.readDir dir;
      files = lib.attrsets.mapAttrs' (name: type:
        if type == "regular" then
          lib.attrsets.nameValuePair name (dir + "/${name}")
        else
          lib.attrsets.nameValuePair name null
      ) items;
      dirs = lib.attrsets.mapAttrs' (name: type:
        if type == "directory" then
          lib.attrsets.nameValuePair name (mapDirectory (dir + "/${name}"))
        else
          lib.attrsets.nameValuePair name null
      ) items;
    in
      files // lib.mapAttrs (name: value: lib.mapAttrs (n: v: "${name}/${v}") value) dirs;

  # Создаем атрибуты для xdg.configFile
  configFiles = lib.mapAttrs'
    (name: value: lib.attrsets.nameValuePair name { source = value; })
    (lib.filterAttrs (n: v: v != null) (lib.attrsets.collapse (mapDirectory (dotfilesDir + "/config"))));

in
{
  # Импорт всех модулей Home Manager
  imports = [
    inputs.self.modules.home-manager.fish
    # inputs.self.modules.home-manager.ghostty # Отключено, так как управляется файлом
    inputs.self.modules.home-manager.hyprland
    inputs.self.modules.home-manager.programs
  ];

  # Общие настройки Home Manager
  home = {
    username = "angeldust";
    homeDirectory = "/home/angeldust";
    stateVersion = "25.05";

    packages = with pkgs; [
      htop
      fastfetch
    ];
  };

  # Настройки для XDG Base Directory Specification
  xdg = {
    enable = true;
    configFile = configFiles;
  };
}
