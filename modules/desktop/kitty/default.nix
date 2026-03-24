{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      hm = {
        programs.kitty = {
          enable = true;
          enableGitIntegration = true;
          shellIntegration.enableFishIntegration = true;

          font = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono NF";

            size = 12;
          };

          themeFile = "Catppuccin-Macchiato";

          settings = {
            window_padding_width = 15;

            cursor_trail = 3;
            cursor_trail_decay = "0.1 0.4";
            cursor_trail_start_threshold = 2;

            copy_on_select = "yes";

            scrollback_lines = 10000;

            font_family = "family='JetBrainsMono NF'";
            bold_font = "family='JetBrainsMono NF' style=SemiBold";
            italic_font = "auto";
            bold_italic_font = "auto";

            clipboard_control = "write-clipboard read-clipboard";

            confirm_os_window_close = 0;
          };
        };
      };
    };
  };
}
