# /home/meflove/git/nixos-config/modules/home-manager/hyprland/hyprlock.nix
{
  programs.hyprlock = {
    enable = true;
    settings =
      let
        colors = import ./colors.nix;
      in
      {
        general = {
          hide_cursor = true;
        };
        background = {
          path = "$HOME/Pictures/wallpaper/lock_screen.png";
          blur_passes = 3;
          color = "rgb(${colors.base})";
        };
        label = [
          {
            text = "$TIME";
            color = "rgb(${colors.text})";
            font_size = 90;
            font_family = "JetBrainsMono Nerd Font";
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }
          {
            text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
            color = "rgb(${colors.text})";
            font_size = 25;
            font_family = "JetBrainsMono Nerd Font";
            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
          {
            text = "$FPRINTPROMPT";
            color = "rgb(${colors.text})";
            font_size = 14;
            font_family = "JetBrainsMono Nerd Font";
            position = "0, -107";
            halign = "center";
            valign = "center";
          }
        ];
        image = {
          # path = "$HOME/Pictures/wallpaper/lock_screen.png";
          size = 100;
          border_color = "rgb(${colors.mauve})";
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
          outer_color = "rgb(${colors.mauve})";
          inner_color = "rgb(${colors.surface0})";
          font_color = "rgb(${colors.text})";
          fade_on_empty = false;
          # placeholder_text = ''
          #   <span foreground="#${colors.text}Alpha"><i>󰌾 Logged in as angeldus</i><span foreground="#${colors.mauve}Alpha">$USER</span></span>'';
          placeholder_text = "Password...";
          hide_input = false;
          check_color = "rgb(${colors.mauve})";
          fail_color = "rgb(${colors.red})";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "rgb(${colors.yellow})";
          position = "0, -47";
          halign = "center";
          valign = "center";
        };
      };
  };
}
