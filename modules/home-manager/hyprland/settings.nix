# /home/meflove/git/nixos-config/modules/home-manager/hyprland/settings.nix
{ ... }:
let
  colors = import ./colors.nix;
in
{
  "general" = {
    gaps_in = 5;
    gaps_out = 12;
    gaps_workspaces = 50;
    border_size = 1;
    "col.active_border" = "rgb(${colors.mauve})";
    "col.inactive_border" = "rgba(595959aa)";
    resize_on_border = true;
    no_focus_fallback = true;
    layout = "dwindle";
    allow_tearing = true;
  };

  "misc" = {
    vfr = 0;
    vrr = 0;
    animate_manual_resizes = false;
    animate_mouse_windowdragging = false;
    enable_swallow = false;
    swallow_regex = "(foot|kitty|allacritty|Alacritty|ghostty|Ghostty|com.mitchellh.ghostty|tmux)";
    disable_hyprland_logo = true;
    force_default_wallpaper = 0;
    new_window_takes_over_fullscreen = 2;
    allow_session_lock_restore = true;
    initial_workspace_tracking = false;
    background_color = "rgba(131315FF)";
  };

  "input" = {
    kb_layout = "us,ru";
    kb_options = "grp:caps_toggle,grp:alt_shift_toggle";
    numlock_by_default = true;
    repeat_delay = 250;
    repeat_rate = 35;

    touchpad = {
      natural_scroll = true;
      disable_while_typing = true;
      clickfinger_behavior = true;
      scroll_factor = 0.5;
    };
    special_fallthrough = true;
    follow_mouse = 1;
  };

  "gestures" = {
    workspace_swipe = true;
    workspace_swipe_distance = 700;
    workspace_swipe_fingers = 4;
    workspace_swipe_cancel_ratio = 0.2;
    workspace_swipe_min_speed_to_force = 5;
    workspace_swipe_direction_lock = true;
    workspace_swipe_direction_lock_threshold = 10;
    workspace_swipe_create_new = true;
  };

  "decoration" = {
    rounding = 10;
    blur = {
      enabled = true;
      xray = true;
      special = true;
      new_optimizations = true;
      size = 3;
      passes = 3;
      brightness = 1;
      vibrancy = 2;
      contrast = 2;
      popups = true;
      popups_ignorealpha = 0.6;
      ignore_opacity = true;
    };
    shadow = {
      enabled = true;
      ignore_window = true;
      range = 4;
      offset = "0 2";
      render_power = 3;
    };
    dim_inactive = false;
    dim_strength = 0.1;
    dim_special = 0;
  };

  "animations" = {
    enabled = true;
    bezier = [
      "easeOutQuint,0.23,1,0.32,1"
      "easeInOutCubic,0.65,0.05,0.36,1"
      "linear,0,0,1,1"
      "almostLinear,0.5,0.5,0.75,1.0"
      "quick,0.15,0,0.1,1"
    ];
    animation = [
      "global, 1, 10, default"
      "border, 1, 5.39, easeOutQuint"
      "windows, 1, 4.79, easeOutQuint"
      "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
      "windowsOut, 1, 1.49, linear, popin 87%"
      "fadeIn, 1, 1.73, almostLinear"
      "fadeOut, 1, 1.46, almostLinear"
      "fade, 1, 3.03, quick"
      "layers, 1, 3.81, easeOutQuint"
      "layersIn, 1, 4, easeOutQuint, fade"
      "layersOut, 1, 1.5, linear, fade"
      "fadeLayersIn, 1, 1.79, almostLinear"
      "fadeLayersOut, 1, 1.39, almostLinear"
      "workspaces, 1, 1.94, almostLinear, fade"
      "workspacesIn, 1, 1.21, almostLinear, fade"
      "workspacesOut, 1, 1.94, almostLinear, fade"
    ];
  };

  "dwindle" = {
    preserve_split = true;
    smart_split = false;
    smart_resizing = true;
  };

  "opengl" = {
    nvidia_anti_flicker = true;
  };

  "cursor" = {
    no_hardware_cursors = true;
    default_monitor = "DP-1";
  };

  "debug" = {
    disable_logs = false;
    full_cm_proto = true;
  };

  "plugin" = {
    dynamic-cursors = {
      enabled = true;
      mode = "stretch";
    };
  };

  "monitor" = [
    "DP-1, highres@highrr, 1920x0, 1, vrr, 1, bitdepth, 10"
    "HDMI-A-1, highres@highrr, 0x360, 1"
  ];
}
