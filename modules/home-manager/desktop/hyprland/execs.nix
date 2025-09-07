# /home/meflove/git/nixos-config/modules/home-manager/hyprland/execs.nix
[
  "swww-daemon --format xrgb"
  # "/usr/lib/geoclue-2.0/demos/agent &"
  # "gnome-keyring-daemon --start --components=secrets"
  # "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1"
  "dbus-update-activation-environment --all"
  "sleep 1 && dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
  # "hyprpm update"
  "clipse -listen"
  # "hyprctl setcursor Bibata-Modern-Classic 20"
  # "gsettings set org.gnome.desktop.interface cursor-size 20"
  # "gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic"
  "easyeffects --gapplication-service"
]
