{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      hm = {
        services.dunst = {
          enable = true;
          settings = {
            global = {
              # Display
              follow = "mouse";
              width = 350;
              height = "(0, 300)";
              origin = "top-right";
              offset = "(35, 35)";
              indicate_hidden = "yes";
              notification_limit = 5;
              gap_size = 12;
              padding = 12;
              horizontal_padding = 20;
              frame_width = 1;
              sort = "no";

              # Progress bar
              progress_bar_frame_width = 0;
              progress_bar_corner_radius = 3;

              # Text
              markup = "full";
              format = "<small>%a</small>\n<b>%s</b>\n%b";
              alignment = "left";
              vertical_alignment = "center";
              show_age_threshold = -1;
              hide_duplicate_count = false;

              # Icon
              icon_position = "left";
              min_icon_size = 54;
              max_icon_size = 80;
              icon_corner_radius = 4;

              # Misc/Advanced
              corner_radius = 10;

              # Mouse
              mouse_left_click = "close_current";
              mouse_middle_click = "do_action, close_current";
              mouse_right_click = "close_all";
            };
          };
        };
      };
    };
  };
}
