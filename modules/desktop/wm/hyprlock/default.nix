{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      inputs,
      config,
      ...
    }: {
      hm = {
        home.file."Pictures/wallpaper/lock_screen.png".source = ../../../../pics/lock_screen.png;
        programs.hyprlock = {
          enable = true;
          settings = {
            general = {
              hide_cursor = true;
            };
            background = {
              path = "${inputs.self}/pics/lock_screen.png";
              blur_passes = 3;
              color = "rgb(${config.lib.stylix.colors.base00})";
            };
            label = [
              {
                text = "$TIME";
                color = "rgb(${config.lib.stylix.colors.base05})";
                font_size = 90;
                font_family = config.stylix.fonts.monospace.name;
                position = "-30, 0";
                halign = "right";
                valign = "top";
              }
              {
                text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
                color = "rgb(${config.lib.stylix.colors.base05})";
                font_size = 25;
                font_family = config.stylix.fonts.monospace.name;
                position = "-30, -150";
                halign = "right";
                valign = "top";
              }
              {
                text = "$FPRINTPROMPT";
                color = "rgb(${config.lib.stylix.colors.base05})";
                font_size = 14;
                font_family = config.stylix.fonts.monospace.name;
                position = "0, -107";
                halign = "center";
                valign = "center";
              }
            ];
            image = {
              # path = "$HOME/Pictures/wallpaper/lock_screen.png";
              size = 100;
              border_color = "rgb(${config.lib.stylix.colors.magenta})";
              position = "0, 75";
              halign = "center";
              valign = "center";
            };
            "input-field" = {
              size = "400, 70";
              outline_thickness = 4;
              dots_size = 0.2;
              dots_spacing = 0.2;
              dots_center = true;
              outer_color = "rgb(${config.lib.stylix.colors.magenta})";
              inner_color = "rgb(${config.lib.stylix.colors.base01})";
              font_color = "rgb(${config.lib.stylix.colors.base05})";
              fade_on_empty = false;
              # placeholder_text = ''
              #   <span foreground="#${colors.text}Alpha"><i>󰌾 Logged in as angeldus</i><span foreground="#${colors.mauve}Alpha">$USER</span></span>'';
              placeholder_text = "Password...";
              hide_input = false;
              check_color = "rgb(${config.lib.stylix.colors.magenta})";
              fail_color = "rgb(${config.lib.stylix.colors.red})";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              capslock_color = "rgb(${config.lib.stylix.colors.yellow})";
              position = "0, -47";
              halign = "center";
              valign = "center";
            };
          };
        };
      };
    };
  };
}
