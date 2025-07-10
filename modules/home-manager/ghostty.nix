{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = null;
    # package = null; # По умолчанию null, так как Ghostty пока не в nixpkgs [17]
    # Если Ghostty будет установлен вручную или через другой метод,
    # этот модуль будет управлять только конфигурационным файлом.

    # Настройки Ghostty [17, 18]
    settings = {
      theme = "catppuccin-mocha"; # Пример темы
      font-size = 10;
      #... другие настройки Ghostty
      keybindings = {
        "super+c" = "copy_to_clipboard";
        "super+v" = "paste_from_clipboard";
        "super+shift+h" = "goto_split:left";
        "super+shift+j" = "goto_split:bottom";
        "super+shift+k" = "goto_split:top";
        "super+shift+l" = "goto_split:right";
        "ctrl+page_up" = "jump_to_prompt:-1";
        #...
      };
    };

    # Очистка стандартных привязок клавиш, если вы хотите полностью кастомные [17]
    # clearDefaultKeybindings = true;

    # Интеграция с оболочкой (по умолчанию включена) [17]
    shellIntegration.enable = true; # Отключить, если управляете вручную
  };
}
