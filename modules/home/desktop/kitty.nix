{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.kitty;

  tokyonightTheme = pkgs.fetchurl {
    url = "https://github.com/folke/tokyonight.nvim/raw/main/extras/kitty/tokyonight_moon.conf";
    sha256 = "sha256-F2mcDp1HI/RLRjEpAABRCfrCsJTcEhbsUE02bTKEBDA=";
  };
in {
  options.${namespace}.home.desktop.kitty = {
    enable =
      lib.mkEnableOption "enable Kitty terminal emulator configuration"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      enableGitIntegration = true;
      shellIntegration.enableFishIntegration = true;

      font = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";

        size = 12;
      };

      settings = {
        window_padding_width = 15;

        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";
        cursor_trail_start_threshold = 2;

        copy_on_select = "yes";

        scrollback_lines = 10000;

        font_family = "family='JetBrainsMono Nerd Font'";
        bold_font = "family='JetBrainsMono Nerd Font' style=SemiBold";
        italic_font = "auto";
        bold_italic_font = "auto";

        clipboard_control = "write-clipboard read-clipboard";

        confirm_os_window_close = 0;
      };

      keybindings = {
        "ctrl+c" = "copy_to_clipboard";
      };

      extraConfig = ''
        include ${tokyonightTheme}
      '';
    };
  };
}
