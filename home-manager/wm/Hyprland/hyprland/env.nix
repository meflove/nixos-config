{
  home.file."~/.config/hypr/hyprland/env.conf".text = ''
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
    # env = WLR_NO_HARDWARE_CURSORS, 1
    
    # ######## Screen tearing #########
    # env = WLR_DRM_NO_ATOMIC, 1
    
    # ############ Others #############
    env = LIBVA_DRIVER_NAME,nvidia
    env = XDG_SESSION_TYPE,wayland
    env = GBM_BACKEND,nvidia-drm
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    
    cursor {
        no_hardware_cursors = true
        default_monitor = DP-3
    }
    env = NVD_BACKEND,direct
    env = ELECTRON_OZONE_PLATFORM_HINT,auto
  '';
}