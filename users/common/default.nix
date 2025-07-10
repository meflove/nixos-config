{ config, pkgs, inputs, ... }:
{
  # Импорт модулей Home Manager для Fish и Ghostty
  # imports = [
  #   inputs.self.modules.home-manager.fish
  #   inputs.self.modules.home-manager.ghostty
  #   inputs.self.modules.home-manager.hyprland # Добавляем Hyprland
  # ];

  # Общие настройки Home Manager
  home = {
    username = "angeldust"; # Укажите ваше имя пользователя
    homeDirectory = "/home/angeldust"; # Укажите путь к вашей домашней директории

    # Дополнительные пакеты, доступные для всех пользователей через Home Manager
    packages = with pkgs; [
      htop
      fastfetch
      # Добавьте другие общие пользовательские пакеты здесь
    ];

    # Управление dotfiles (пример)
    # home.file.".config/my-app/config.conf".source =./files/my-app-config.conf;
  };

  # Настройки для XDG Base Directory Specification
  # Это помогает организовать файлы конфигурации в ~/.config, ~/.local/share и т.д.
  xdg.enable = true;
  xdg.configFile."mimeapps.list".source = "${config.xdg.configHome}/mimeapps.list";

  # Настройка Git (пример)
  programs.git = {
    enable = true;
    userName = "meflove";
    userEmail = "meflov3r@gmail.com";
  };

  # Настройка GnuPG (пример)
  programs.gnupg.enable = true;

  # Настройка SSH (пример)
  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    "github.com" = {
      user = "git";
      identityFile = "~/.ssh/id_ed25519";
    };
  };

  # Установите версию Home Manager. Это помогает избежать проблем при обновлении Home Manager.
  # Вы можете обновить Home Manager, не меняя это значение.
  home.stateVersion = "25.05"; # Или актуальная версия Home Manager
}
