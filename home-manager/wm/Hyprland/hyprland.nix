{
  home.file."~/.config/hypr/hyprland.conf".text = ''
    # This file sources other files in `hyprland` and `custom` folders
    # You wanna add your stuff in file in `custom`
    
    # Defaults
    source=~/.config/hypr/hyprland/env.conf
    source=~/.config/hypr/hyprland/execs.conf
    source=~/.config/hypr/hyprland/general.conf
    source=~/.config/hypr/hyprland/rules.conf
    source=~/.config/hypr/hyprland/colors.conf
    source=~/.config/hypr/hyprland/keybinds.conf
    
    opengl {
        nvidia_anti_flicker = true
    }
  '';
}