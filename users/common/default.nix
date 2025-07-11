{ config, pkgs, inputs, ... }:
{
  # Импорт всех модулей Home Manager
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

    packages = with pkgs; [
      htop
      fastfetch
    ];
  };

  # Настройки для XDG Base Directory Specification
  xdg = {
    enable = true;
    # configFile."mimeapps.list".source = "${config.xdg.configHome}/mimeapps.list";
  };
}
