{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      hm = {
        programs.kitty = {
          enable = true;
          enableGitIntegration = true;
          shellIntegration = {
            enableFishIntegration = true;
          };

          settings = {
            window_padding_width = 9;

            cursor_trail = 3;
            cursor_trail_decay = "0.1 0.4";
            cursor_trail_start_threshold = 2;

            copy_on_select = "yes";

            scrollback_lines = 10000;

            clipboard_control = "write-clipboard read-clipboard";

            confirm_os_window_close = 0;
          };
        };
      };
    };
  };
}
