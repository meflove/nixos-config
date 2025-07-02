{ config, lib, pkgs, ... }:

let
  cfg = config.wayland.windowManager.hyprland;
  # Helper to convert Hyprland config sections to NixOS options
  mkOption = type: default: description: {
    inherit type description default;
  };
in
{
  wayland.windowManager.hyprland.enable = true;

  options.wayland.windowManager.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager";
  };

  config = lib.mkIf cfg.enable {
    # Enable Hyprland in Home Manager
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true; # Enable XWayland for compatibility

      # Import color definitions
      extraConfig = builtins.readFile ./colors.nix;

      # General configuration
      settings = {
        # MONITOR CONFIG
        monitor = [
          "DP-1,2560x1440@144,1920x0,1,vrr,1"
          "HDMI-A-1,1920x1080@60,0x360,1"
          # "HDMI-A-1,1920x1080@60,1920x0,1,mirror,eDP-1" # HDMI port: mirror display. To see device name, use `hyprctl monitors`
        ];

        input = {
          kb_layout = "us,ru";
          kb_options = "grp:alt_shift_toggle,grp:caps_toggle";
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

        binds = {
          # focus_window_on_workspace_c# For Auto-run stuff see execs.confhange = true
          scroll_event_delay = 0;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_distance = 700;
          workspace_swipe_fingers = 4;
          workspace_swipe_cancel_ratio = 0.2;
          workspace_swipe_min_speed_to_force = 5;
          workspace_swipe_direction_lock = true;
          workspace_swipe_direction_lock_threshold = 10;
          workspace_swipe_create_new = true;
        };

        general = {
          gaps_in = 6;
          gaps_out = 13;
          gaps_workspaces = 50;
          border_size = 5;

          "col.active_border" = "rgba(0DB7D4FF)";
          "col.inactive_border" = "rgba(31313600)";

          resize_on_border = true;
          no_focus_fallback = true;
          layout = "dwindle";

          allow_tearing = true;
        };

        dwindle = {
          preserve_split = true;
          smart_split = false;
          smart_resizing = false;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.4, 0, 0.2, 1";
          animation = [
            "windows, 1, 2.5, myBezier, popin 80%"
            "border, 1, 2.5, myBezier"
            "fade, 1, 2.5, myBezier"
            "workspaces, 1, 2.5, myBezier, slidefade 20%"
          ];
        };

        decoration = {
          rounding = 20;
          blur = {
            enabled = true;
            xray = true;
            special = false;
            new_optimizations = true;
            size = 4;
            passes = 4;
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
            range = 20;
            offset = "0 2";
            render_power = 4;
            color = "rgba(0000002A)";
          };
          dim_inactive = false;
          dim_strength = 0.1;
          dim_special = 0;
        };

        misc = {
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
        };

        debug = {
          disable_logs = false;
          full_cm_proto = true;
        };

        plugin = {
          hyprexpo = {
            columns = 3;
            gap_size = 5;
            bg_col = "rgb(000000)";
            workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1

            enable_gesture = false;
            gesture_distance = 300;
            gesture_positive = false;
          };
        };
      };

      # Keybinds
      bind = [
        # Essentials for beginners
        "Super, T, exec, ghostty" # Launch kitty (terminal)
        "Super, Return, exec, ghostty" # [hidden] # In case you're from i3 or its Wayland clone
        ", Super, exec, true" # Open app launcher
        "Alt+Super, T, exec, ~/.config/ags/scripts/color_generation/switchwall.sh" # Change wallpaper
        # Actions
        # Screenshot, Record, OCR, Color picker, Clipboard history
        "Super, V, exec, pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy" # Clipboard history >> clipboard
        "Super, Period, exec, pkill fuzzel || ~/.local/bin/fuzzel-emoji" # Pick emoji >> clipboard
        "Ctrl+Shift+Alt, Delete, exec, pkill wlogout || wlogout -p layer-shell" # [hidden]
        ",Print, exec, ~/.config/ags/scripts/grimblast.sh --freeze copy area" # Screen snip
        "Super+Shift+Alt, S, exec, grim -g \"$(slurp)\" - | swappy -f -" # Screen snip >> edit
        # OCR
        "Super+Ctrl,T,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract -l eng \"tmp.png\" - | wl-copy && rm \"tmp.png\"" # Screen snip to text >> clipboard
        "Ctrl+Super+Shift,S,exec,grim -g \"$(slurp $SLURP_ARGS)\" \"tmp.png\" && tesseract \"tmp.png\" - | wl-copy && rm \"tmp.png\"" # [hidden]
        # Color picker
        "Super+Shift, C, exec, hyprpicker -ar" # Pick color (Hex) >> clipboard
        # Fullscreen screenshot
        # "bindl=,Print,exec,grim - | wl-copy" # Screenshot >> clipboard
        "Ctrl+Shift,Print, exec, mkdir -p ~/Images/Screenshots && ~/.config/ags/scripts/grimblast.sh copysave screen ~/Pictures/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png" # Screenshot >> clipboard & file
        # Session
        "Super, X, exec, bash ~/.config/rofi/powermenu.sh"
        "Super, G, exec, pkill rofi || rofi -show calc -modi calc -no-show-match -no-sort -theme \"$HOME/.config/rofi/launchers/type-6/style-10.rasi\""
        "Super, L, exec, hyprlock" # Lock
        "Super+Shift, L, exec, loginctl lock-session" # [hidden]
        "Super+Shift, L, exec, sleep 0.1 && systemctl suspend || loginctl suspend" # Suspend system
        "Ctrl+Shift+Alt+Super, Delete, exec, systemctl poweroff || loginctl poweroff" # [hidden] Power off

        # Window management
        # Focusing
        "Super, Left, movefocus, l" # [hidden]
        "Super, Right, movefocus, r" # [hidden]
        "Super, Up, movefocus, u" # [hidden]
        "Super, Down, movefocus, d" # [hidden]
        "Super, BracketLeft, movefocus, l" # [hidden]
        "Super, BracketRight, movefocus, r" # [hidden]
        "Super, mouse:272, movewindow"
        "Super, mouse:273, resizewindow"
        "Super, Q, killactive,"
        "Super+Shift+Alt, Q, exec, hyprctl kill" # Pick and kill a window
        # Window arrangement
        "Super+Shift, Left, movewindow, l" # [hidden]
        "Super+Shift, Right, movewindow, r" # [hidden]
        "Super+Shift, Up, movewindow, u" # [hidden]
        "Super+Shift, Down, movewindow, d" # [hidden]
        # Window split ratio
        "Super, Minus, splitratio, -0.1" # [hidden]
        "Super, Equal, splitratio, +0.1" # [hidden]
        "Super, Semicolon, splitratio, -0.1" # [hidden]
        "Super, Apostrophe, splitratio, +0.1" # [hidden]
        # Positioning mode
        "Super+Alt, Space, togglefloating,"
        "Super+Alt, F, fullscreenstate, 0 3" # Toggle fake fullscreen
        "Super, F, fullscreen, 0"
        "Super, D, fullscreen, 1"

        # Workspace navigation
        # Switching
        "Super, 1, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 1" # [hidden]
        "Super, 2, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 2" # [hidden]
        "Super, 3, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 3" # [hidden]
        "Super, 4, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 4" # [hidden]
        "Super, 5, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 5" # [hidden]
        "Super, 6, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 6" # [hidden]
        "Super, 7, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 7" # [hidden]
        "Super, 8, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 8" # [hidden]
        "Super, 9, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 9" # [hidden]
        "Super, 0, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh workspace 10" # [hidden]

        "Ctrl+Super, Right, workspace, +1" # [hidden]
        "Ctrl+Super, Left, workspace, -1" # [hidden]
        "Super, mouse_up, workspace, +1" # [hidden]
        "Super, mouse_down, workspace, -1" # [hidden]
        "Ctrl+Super, mouse_up, workspace, +1" # [hidden]
        "Ctrl+Super, mouse_down, workspace, -1" # [hidden]
        "Super, Page_Down, workspace, +1" # [hidden]
        "Super, Page_Up, workspace, -1" # [hidden]
        "Ctrl+Super, Page_Down, workspace, +1" # [hidden]
        "Ctrl+Super, Page_Up, workspace, -1" # [hidden]
        # Special
        "Super, S, togglespecialworkspace,"
        "Super, mouse:275, togglespecialworkspace,"

        # Workspace management
        # Move window to workspace Super + Alt + [0-9]
        "Super+Alt, 1, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 1" # [hidden]
        "Super+Alt, 2, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 2" # [hidden]
        "Super+Alt, 3, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 3" # [hidden]
        "Super+Alt, 4, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 4" # [hidden]
        "Super+Alt, 5, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 5" # [hidden]
        "Super+Alt, 6, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 6" # [hidden]
        "Super+Alt, 7, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 7" # [hidden]
        "Super+Alt, 8, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 8" # [hidden]
        "Super+Alt, 9, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 9" # [hidden]
        "Super+Alt, 0, exec, ~/.config/ags/scripts/hyprland/workspace_action.sh movetoworkspacesilent 10" # [hidden]

        "Ctrl+Super+Shift, Up, movetoworkspacesilent, special" # [hidden]

        "Ctrl+Super+Shift, Right, movetoworkspace, +1" # [hidden]
        "Ctrl+Super+Shift, Left, movetoworkspace, -1" # [hidden]
        "Ctrl+Super, BracketLeft, workspace, -1" # [hidden]
        "Ctrl+Super, BracketRight, workspace, +1" # [hidden]
        "Ctrl+Super, Up, workspace, -5" # [hidden]
        "Ctrl+Super, Down, workspace, +5" # [hidden]
        "Super+Shift, mouse_down, movetoworkspace, -1" # [hidden]
        "Super+Shift, mouse_up, movetoworkspace, +1" # [hidden]
        "Super+Alt, mouse_down, movetoworkspace, -1" # [hidden]
        "Super+Alt, mouse_up, movetoworkspace, +1" # [hidden]
        "Super+Alt, Page_Down, movetoworkspace, +1" # [hidden]
        "Super+Alt, Page_Up, movetoworkspace, -1" # [hidden]
        "Super+Shift, Page_Down, movetoworkspace, +1" # [hidden]
        "Super+Shift, Page_Up, movetoworkspace, -1" # [hidden]
        "Super+Alt, S, movetoworkspacesilent, special"
        "Super, P, pin"

        "Ctrl+Super, S, togglespecialworkspace," # [hidden]
        "Alt, Tab, cyclenext" # [hidden] sus keybind
        "Alt, Tab, bringactivetotop," # [hidden] bring it to the top

        # Widgets
        "Ctrl+Super, R, exec, hyprpanel" # Restart widgets
        "Ctrl+Super+Alt, R, exec, hyprctl reload; killall ags ydotool; ags &" # [hidden]
        "Super, Super_L, exec, pkill rofi || rofi -show drun -config ~/.config/rofi/configsbspwm.rasi" # Toggle overview/launcher
        # "Super, Super_L, exec, pkill otter-launcher || \"$HOME/.config/otter-launcher/otter-toggle-hyprland\"" # Toggle overview/launcher
        # "Super, Slash, exec, bash ~/.config/rofi/rofi_keybinds.sh" # Show cheatsheet

        # Testing
        # "SuperAlt, f12, exec, notify-send \"Hyprland version: $(hyprctl version | head -2 | tail -1 | cut -f2 -d ' ')\" \"owo\" -a 'Hyprland keybind'"
        # "Super+Alt, f12, exec, notify-send \"Millis since epoch\" \"$(date +%s%N | cut -b1-13)\" -a 'Hyprland keybind'"
        "Super+Alt, f12, exec, notify-send 'Test notification' \"Here's a really long message to test truncation and wrapping\\nYou can middle click or flick this notification to dismiss it!\" -a 'Shell' -A \"Test1=I got it!\" -A \"Test2=Another action\" -t 5000" # [hidden]
        "Super+Alt, Equal, exec, notify-send \"Urgent notification\" \"Ah hell no\" -u critical -a 'Hyprland keybind'" # [hidden]

        # Media
        "Super+Shift, N, exec, playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`" # Next track
        "Super+Shift+Alt, mouse:275, exec, playerctl previous" # [hidden]
        "Super+Shift+Alt, mouse:276, exec, playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`" # [hidden]
        "Super+Shift, B, exec, playerctl previous" # Previous track
        "Super+Shift, P, exec, playerctl play-pause" # Play/pause media

        # Apps
        "Super, T, exec, ghostty" # Launch ghostty (terminal)
        "Super, Z, exec, Zed" # Launch Zed (editor)
        "Super, C, exec, ghostty -e nvim" # Launch NeoVim (editor)
        "Super, E, exec, nemo" # Launch Nautilus (file manager)
        "Super+Alt, E, exec, thunar" # [hidden]
        "Super, W, exec, zen-browser" # [hidden] Let's not give people (more) reason to shit on my rice
        "Ctrl+Super, W, exec, firefox" # Launch Firefox (browser)
        "Super+Shift, W, exec, wps" # Launch WPS Office
        "Super, I, exec, XDG_CURRENT_DESKTOP=\"gnome\" gnome-control-center" # Launch GNOME Settings
        "Ctrl+Super, V, exec, pavucontrol" # Launch pavucontrol (volume mixer)
        "Ctrl+Super+Shift, V, exec, easyeffects" # Launch EasyEffects (equalizer & other audio effects)
        "Ctrl+Shift, Escape, exec, gnome-system-monitor" # Launch GNOME System monitor
        "Ctrl+Super, Slash, exec, pkill anyrun || anyrun" # Toggle fallback launcher: anyrun
        "Super+Alt, Slash, exec, pkill anyrun || fuzzel" # Toggle fallback launcher: fuzzel
        "Super+Shift, T, exec, ayugram-desktop" # Launch Ayugram
        "Super+Shift, D, exec, equibop" # Launch Discord
        "Super, S, exec, spotify-launcher" # Launch Spotify
        "Super, K, exec, ghostty -e calcurse" # Launch calendar

        # Cursed stuff
        "Ctrl+Super, Backslash, resizeactive, exact 640 480" # [hidden]
      ];

      # Window rules
      windowRules = [
        "opacity 0.89 override 0.89 override, title:^(.*)$" # Applies transparency to EVERY WINDOW
        "float, title:^(blueberry.py)$"
        "float, title:^(steam)$"
        "float, title:^(guifetch)$" # FlafyDev/guifetch
        "tile, class:(dev.warp.Warp)"
        "tile, title:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
        "center, title:^(Open File)(.*)$"
        "center, title:^(Select a File)(.*)$"
        "center, title:^(Choose wallpaper)(.*)$"
        "center, title:^(Open Folder)(.*)$"
        "center, title:^(Save As)(.*)$"
        "center, title:^(Library)(.*)$"
        "center, title:^(File Upload)(.*)$"
        "center, title:^(Extract)(.*)$"
        "center, title:^(Wine configuration)(.*)$"
        "center, title:^(Blobdrop)(.*)$"
        "float, title:^(Blobdrop)(.*)$"
        "center, class:^(com.example.otter-launcher)$"
        "float, class:^(com.example.otter-launcher)$"
        "center, title:^(otter-launcher)$"
        "float, title:^(otter-launcher)$"

        # Picture-in-Picture
        "keepaspectratio, title:^(Picture(-| )in(-| )[Pp]icture)$"
        "move 73% 72%,title:^(Picture(-| )in(-| )[Pp]icture)$"
        "size 25%, title:^(Picture(-| )in(-| )[Pp]icture)$"
        "float, title:^(Picture(-| )in(-| )[Pp]icture)$"
        "pin, title:^(Picture(-| )in(-| )[Pp]icture)$"

        # Dialogs
        "float,title:^(Open File)(.*)$"
        "float,title:^(Select a File)(.*)$"
        "float,title:^(Choose wallpaper)(.*)$"
        "float,title:^(Open Folder)(.*)$"
        "float,title:^(Save As)(.*)$"
        "float,title:^(Library)(.*)$"
        "float,title:^(File Upload)(.*)$"
        "float,title:^(Extract)(.*)$"
        # Tearing
        "immediate,title:^(.*\\.exe)$"
        "immediate,class:(steam_app)"

        # No shadow for tiled windows
        "noshadow,floating:0"
      ];

      # Layer rules
      layerRules = [
        "xray 1, .*"
        # "noanim, .*"
        "noanim, walker"
        "noanim, selection"
        "noanim, overview"
        "noanim, anyrun"
        "noanim, indicator.*"
        "noanim, osk"
        "noanim, hyprpicker"
        "blur, shell:*"
        "ignorealpha 0.6, shell:*"

        "noanim, noanim"
        "blur, gtk-layer-shell"
        "ignorezero, gtk-layer-shell"
        "blur, launcher"
        "ignorealpha 0.5, launcher"
        "blur, notifications"
        "ignorealpha 0.69, notifications"

        # ags
        "animation slide left, sideleft.*"
        "animation slide right, sideright.*"
        "blur, session"

        "blur, bar"
        "ignorealpha 0.6, bar"
        "blur, corner.*"
        "ignorealpha 0.6, corner.*"
        "blur, dock"
        "ignorealpha 0.6, dock"
        "blur, indicator.*"
        "ignorealpha 0.6, indicator.*"
        "blur, overview"
        "ignorealpha 0.6, overview"
        "blur, cheatsheet"
        "ignorealpha 0.6, cheatsheet"
        "blur, sideright"
        "ignorealpha 0.6, sideright"
        "blur, sideleft"
        "ignorealpha 0.6, sideleft"
        "blur, indicator*"
        "ignorealpha 0.6, indicator*"
        "blur, osk"
        "ignorealpha 0.6, osk"
      ];

      # Environment variables
      extraConfig = ''
        # ######### Input method ##########
        # See https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
        env = QT_IM_MODULE, fcitx
        env = XMODIFIERS, @im=fcitx
        # env = GTK_IM_MODULE, wayland   # Crashes electron apps in xwayland
        # env = GTK_IM_MODULE, fcitx     # My Gtk apps no longer require this to work with fcitx5 hmm
        env = SDL_IM_MODULE, fcitx
        env = GLFW_IM_MODULE, ibus
        env = INPUT_METHOD, fcitx

        # ############ Themes #############
        env = QT_QPA_PLATFORM, wayland
        env = QT_QPA_PLATFORMTHEME, qt5ct
        # env = QT_STYLE_OVERRIDE,kvantum
        env = WLR_NO_HARDWARE_CURSORS, 1

        # ######## Screen tearing #########
        # env = WLR_DRM_NO_ATOMIC, 1

        # ############ Others #############
        env = LIBVA_DRIVER_NAME,nvidia
        env = XDG_SESSION_TYPE,wayland
        env = GBM_BACKEND,nvidia-drm
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        env = WLR_RENDERER,vulkan
        cursor {
            no_hardware_cursors = true
            default_monitor = DP-1
        }
        env = NVD_BACKEND,direct
        env = ELECTRON_OZONE_PLATFORM_HINT,wayland

        # OpenGL
        opengl {
            nvidia_anti_flicker = true
        }
      '';

      # Exec-once commands
      extraConfig = ''
        # Bar, wallpaper
        exec-once = swww-daemon --format xrgb
        exec-once = /usr/lib/geoclue-2.0/demos/agent &
        exec-once = hyprpanel

        # Input method
        exec-once = fcitx5

        # Core components (authentication, lock screen, notification daemon)
        exec-once = gnome-keyring-daemon --start --components=secrets
        exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1
        exec-once = dbus-update-activation-environment --all
        exec-once = sleep 1 && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # Some fix idk
        exec-once = hyprpm update

        # Clipboard: history
        # exec-once = wl-paste --watch cliphist store &
        exec-once = wl-paste --type text --watch cliphist store
        exec-once = wl-paste --type image --watch cliphist store

        # Cursor
        exec-once = hyprctl setcursor Bibata-Modern-Classic 20
        exec-once = gsettings set org.gnome.desktop.interface cursor-size 20
        exec-once = gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic

        # Other
        exec = easyeffects --gapplication-service
      '';
    };

    # Hypridle configuration
    services.hypridle = {
      enable = true;
      timeout = [
        {
          timeout = 180; # 3mins
          command = "loginctl lock-session";
        }
        {
          timeout = 240; # 4mins
          command = "hyprctl dispatch dpms off";
          onResume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 540; # 9mins
          command = "pidof steam || systemctl suspend || loginctl suspend"; # fuck nvidia
        }
      ];
      beforeSleep = "loginctl lock-session";
      lockCommand = "pidof hyprlock || hyprlock";
    };

    # Hyprlock configuration
    programs.hyprlock = {
      enable = true;
      settings = {
        # Source mocha.conf for colors
        source = "${config.xdg.configHome}/hypr/mocha.conf";

        # Define variables from mocha.conf
        # These should be defined in mocha.conf and sourced.
        # For NixOS, we might need to explicitly define them or ensure mocha.conf is correctly sourced.
        # For now, let's assume mocha.conf is correctly placed and sourced by hyprlock.
        # If hyprlock doesn't pick up variables from sourced files in NixOS,
        # you might need to define them here or pass them as environment variables.
        accent = "$mauve";
        accentAlpha = "$mauveAlpha";
        font = "JetBrainsMono Nerd Font";

        general = {
          hide_cursor = true;
        };

        background = {
          monitor = "";
          path = "$HOME/.config/background";
          blur_passes = 3;
          color = "$base";
        };

        label = [
          {
            monitor = "";
            text = "$TIME";
            color = "$text";
            font_size = 90;
            font_family = "$font";
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }
          {
            monitor = "";
            text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
            color = "$text";
            font_size = 25;
            font_family = "$font";
            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
          {
            monitor = "";
            text = "$FPRINTPROMPT";
            color = "$text";
            font_size = 14;
            font_family = "font";
            position = "0, -107";
            halign = "center";
            valign = "center";
          }
        ];

        image = {
          monitor = "";
          path = "$HOME/.face";
          size = 100;
          border_color = "$accent";
          position = "0, 75";
          halign = "center";
          valign = "center";
        };

        "input-field" = {
          monitor = "";
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          fade_on_empty = false;
          placeholder_text = "<span foreground=\"##$textAlpha\"><i>󰌾 Logged in as </i><span foreground=\"##$accentAlpha\">$USER</span></span>";
          hide_input = false;
          check_color = "$accent";
          fail_color = "$red";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "$yellow";
          position = "0, -47";
          halign = "center";
          valign = "center";
        };
      };
    };

    # Ensure necessary packages are installed
    home.packages = with pkgs; [
      hyprland
      hypridle
      hyprlock
      swww
      hyprpanel
      fcitx5
      gnome-keyring
      polkit-gnome
      dbus
      wl-clipboard
      cliphist
      grim
      slurp
      swappy
      tesseract # for OCR
      hyprpicker
      wlogout
      rofi
      playerctl
      nemo # or thunar
      firefox
      wps-office # if available in nixpkgs or an overlay
      gnome.gnome-control-center
      pavucontrol
      easyeffects
      gnome-system-monitor
      anyrun
      fuzzel
      ayugram-desktop # if available
      discord # if available
      spotify # if available
      calcurse
      bc # for playerctl calculations
    ];

    # Manage dotfiles for scripts and other configurations
    home.file."${config.xdg.configHome}/hypr/mocha.conf".source = ./mocha.conf;
    home.file."${config.xdg.configHome}/hypr/colors.conf".source = ./colors.conf; # This is likely redundant if colors are in default.nix
    home.file."${config.xdg.configHome}/ags/scripts/color_generation/switchwall.sh".source = ../../../dotfiles/config/ags/scripts/color_generation/switchwall.sh; # Adjust path as needed
    home.file."${config.xdg.configHome}/rofi/powermenu.sh".source = ../../../dotfiles/config/rofi/powermenu.sh; # Adjust path as needed
    home.file."${config.xdg.configHome}/rofi/configsbspwm.rasi".source = ../../../dotfiles/config/rofi/configsbspwm.rasi; # Adjust path as needed
    home.file."${config.xdg.configHome}/ags/scripts/grimblast.sh".source = ../../../dotfiles/config/ags/scripts/grimblast.sh; # Adjust path as needed
    home.file."${config.xdg.configHome}/ags/scripts/hyprland/workspace_action.sh".source = ../../../dotfiles/config/ags/scripts/hyprland/workspace_action.sh; # Adjust path as needed
    home.file."${config.xdg.dataHome}/bin/fuzzel-emoji".source = ../../../dotfiles/local/bin/fuzzel-emoji; # Adjust path as needed
  };
}


