{
  home.file."~/.config/hypr/hyprland/general.conf".text = ''
    # MONITOR CONFIG
    monitor=DP-3,2560x1440@143.972,1920x0,1
    monitor=HDMI-A-1,1920x1080@60,0x360,1
    
    # HDMI port: mirror display. To see device name, use `hyprctl monitors`
    # monitor=HDMI-A-1,1920x1080@60,1920x0,1,mirror,eDP-1
    
    input {
        # Keyboard: Add a layout and uncomment kb_options for Win+Space switching shortcut
        kb_layout = us,ru
        kb_options = grp:alt_shift_toggle
        numlock_by_default = true
        repeat_delay = 250
        repeat_rate = 35
    
        touchpad {
            natural_scroll = yes
            disable_while_typing = true
            clickfinger_behavior = true
            scroll_factor = 0.5
        }
        special_fallthrough = true
        follow_mouse = 1
    }
    
    binds {
        # focus_window_on_workspace_c# For Auto-run stuff see execs.confhange = true
        scroll_event_delay = 0
    }
    
    gestures {
        workspace_swipe = true
        workspace_swipe_distance = 700
        workspace_swipe_fingers = 4
        workspace_swipe_cancel_ratio = 0.2
        workspace_swipe_min_speed_to_force = 5
        workspace_swipe_direction_lock = true
        workspace_swipe_direction_lock_threshold = 10
        workspace_swipe_create_new = true
    }
    
    general {
        # Gaps and border
        gaps_in = 6
        gaps_out = 13
        gaps_workspaces = 50
        border_size = 5
        
        # Fallback colors
        col.active_border = rgba(0DB7D4FF)
        col.inactive_border = rgba(31313600)
    
        resize_on_border = true
        no_focus_fallback = true
        layout = dwindle
        
        #focus_to_other_workspaces = true # ahhhh i still haven't properly implemented this
        allow_tearing = true # This just allows the `immediate` window rule to work
    }
    
    dwindle {
    	preserve_split = true
            # no_gaps_when_only = 1
    	smart_split = false
    	smart_resizing = false
    }
    
    decoration {
        rounding = 20
        
        blur {
            enabled = true
            xray = true
            special = false
            new_optimizations = true
            size = 2
            passes = 4
            brightness = 1
            noise = 0.01
            contrast = 1
            popups = true
            popups_ignorealpha = 0.6
        }
        # Shadow
        shadow {
            enabled = true
            ignore_window = true
            range = 20
            offset = 0 2
            render_power = 4
            color = rgba(0000002A)
        }
        
        # Shader
        # screen_shader = ~/.config/hypr/shaders/drugs.frag
        # screen_shader = ~/.config/hypr/shaders/extradark.frag
        
        # Dim
        dim_inactive = false
        dim_strength = 0.1
        dim_special = 0
    }
    
    animations {
        # enabled = true
        # # Animation curves
        #
        # bezier = linear, 0, 0, 1, 1
        # bezier = md3_standard, 0.2, 0, 0, 1
        # bezier = md3_decel, 0.05, 0.7, 0.1, 1
        # bezier = md3_accel, 0.3, 0, 0.8, 0.15
        # bezier = overshot, 0.05, 0.9, 0.1, 1.1
        # bezier = crazyshot, 0.1, 1.5, 0.76, 0.92 
        # bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
        # bezier = menu_decel, 0.1, 1, 0, 1
        # bezier = menu_accel, 0.38, 0.04, 1, 0.07
        # bezier = easeInOutCirc, 0.85, 0, 0.15, 1
        # bezier = easeOutCirc, 0, 0.55, 0.45, 1
        # bezier = easeOutExpo, 0.16, 1, 0.3, 1
        # bezier = softAcDecel, 0.26, 0.26, 0.15, 1
        # bezier = md2, 0.4, 0, 0.2, 1 # use with .2s duration
        # # Animation configs
        # animation = windows, 1, 3, md3_decel, popin 60%
        # animation = windowsIn, 1, 3, md3_decel, popin 60%
        # animation = windowsOut, 1, 3, md3_accel, popin 60%
        # animation = border, 1, 10, default
        # animation = fade, 1, 3, md3_decel
        # # animation = layers, 1, 2, md3_decel, slide
        # animation = layersIn, 1, 3, menu_decel, slide
        # animation = layersOut, 1, 1.6, menu_accel
        # animation = fadeLayersIn, 1, 2, menu_decel
        # animation = fadeLayersOut, 1, 4.5, menu_accel
        # animation = workspaces, 1, 7, menu_decel, slide
        # # animation = workspaces, 1, 2.5, softAcDecel, slide
        # # animation = workspaces, 1, 7, menu_decel, slidefade 15%
        # # animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
        # animation = specialWorkspace, 1, 3, md3_decel, slidevert
    
        enabled = yes, please :)
    
        
        bezier = easeOutQuint,0.23,1,0.32,1
        bezier = easeInOut,0.68,0,0.32,1
        bezier = linear,0,0,1,1
        bezier = almostLinear,0.5,0.5,0.75,1.0
        bezier = quick,0.15,0,0.1,1
    
        animation = global, 1, 10, default
        animation = border, 1, 5.39, easeOutQuint
        animation = windows, 1, 4.79, easeOutQuint
        animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
        animation = windowsOut, 1, 1.49, linear, popin 87%
        animation = fadeIn, 1, 1.73, almostLinear
        animation = fadeOut, 1, 1.46, almostLinear
        animation = fade, 1, 3.03, quick
        animation = layers, 1, 3.81, easeOutQuint
        animation = layersIn, 1, 4, easeOutQuint, fade
        animation = layersOut, 1, 1.5, linear, fade
        animation = fadeLayersIn, 1, 1.79, almostLinear
        animation = fadeLayersOut, 1, 1.39, almostLinear
        animation = workspaces, 1, 3, easeInOut, slidefade
    
    }
    
    misc {
        vfr = 1
        vrr = 1
        animate_manual_resizes = false
        animate_mouse_windowdragging = false
        enable_swallow = false
        swallow_regex = (foot|kitty|allacritty|Alacritty)
        
        disable_hyprland_logo = true
        force_default_wallpaper = 0
        new_window_takes_over_fullscreen = 2
        allow_session_lock_restore = true
        
        initial_workspace_tracking = false
    }
    
    # Overview
    plugin {
        hyprexpo {
            columns = 3
            gap_size = 5
            bg_col = rgb(000000)
            workspace_method = first 1 # [center/first] [workspace] e.g. first 1 or center m+1
    
            enable_gesture = false # laptop touchpad, 4 fingers
            gesture_distance = 300 # how far is the "max"
            gesture_positive = false
        }
    }  
  '';
}