{ config, pkgs, lib, ... }:
{
  programs.ghostty = {
    enable = true;
    # package = null; # Ghostty пока не в nixpkgs

    settings = {
      theme = "catppuccin-mocha";
      font-size = 10;
      
      # Привязки клавиш
      keybindings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          "super+c" = "copy_to_clipboard";
          "super+v" = "paste_from_clipboard";
          "super+shift+h" = "goto_split:left";
          "super+shift+j" = "goto_split:bottom";
          "super+shift+k" = "goto_split:top";
          "super+shift+l" = "goto_split:right";
          "ctrl+page_up" = "jump_to_prompt:-1";
        };
      };

      # Интеграция с оболочкой
      "shell-integration" = "fish";
    };
  };
}
