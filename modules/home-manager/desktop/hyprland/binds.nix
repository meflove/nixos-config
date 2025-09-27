# /home/meflove/git/nixos-config/modules/home-manager/hyprland/binds.nix
[
  # Essentials
  "Super, T, exec, ghostty"
  "Super, Return, exec, ghostty"
  ", Super, exec, true"

  # Actions
  ''Super, V, exec, pkill clipse || ghostty --class="com.free.clipse" --title="clipse" -e clipse''
  "Super, Period, exec, pkill fuzzel || ~/.config/scripts/fuzzel-emoji"
  "Ctrl+Shift+Alt, Delete, exec, pkill wlogout || wlogout -p layer-shell"
  ",Print, exec, ~/.config/scripts/grimblast.sh --freeze copy area"
  ''Super+Shift+Alt, S, exec, grim -g "$(slurp)" - | swappy -f -''
  ''Super+Ctrl,T,exec, grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"''
  ''Ctrl+Super+Shift,S,exec,grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract "tmp.png" - | wl-copy && rm "tmp.png"''
  "Super+Shift, C, exec, hyprpicker -ar"
  ''Ctrl+Shift,Print, exec, mkdir -p ~/Pictures/Screenshots && ~/.config/scripts/grimblast.sh copysave screen ~/Pictures/Screenshots/Screenshot_"$(date '+%Y-%m-%d_%H.%M.%S')".png''

  # Session
  "Super, X, exec, bash ~/.config/rofi/powermenu.sh"
  ''Super, G, exec, pkill kalker || ghostty --class="com.free.kalker" --title="kalker" -e kalker''
  "Super, L, exec, hyprlock"
  "Super+Shift, L, exec, loginctl lock-session"
  "Super+Shift, L, exec, sleep 0.1 && systemctl suspend || loginctl suspend"
  "Ctrl+Shift+Alt+Super, Delete, exec, systemctl poweroff || loginctl poweroff"

  # Window management
  "Super, Left, movefocus, l"
  "Super, Right, movefocus, r"
  "Super, Up, movefocus, u"
  "Super, Down, movefocus, d"
  "Super, BracketLeft, movefocus, l"
  "Super, BracketRight, movefocus, r"
  "Super, Q, killactive,"
  "Super+Shift+Alt, Q, exec, hyprctl kill"

  # Window arrangement
  "Super+Shift, Left, movewindow, l"
  "Super+Shift, Right, movewindow, r"
  "Super+Shift, Up, movewindow, u"
  "Super+Shift, Down, movewindow, d"
  "Super, Minus, splitratio, -0.1"
  "Super, Equal, splitratio, +0.1"
  "Super, Semicolon, splitratio, -0.1"
  "Super, Apostrophe, splitratio, +0.1"
  "Super+Alt, Space, togglefloating,"
  "Super+Alt, F, fullscreenstate, 0 3"
  "Super, F, fullscreen, 0"
  "Super, D, fullscreen, 1"

  # Workspace navigation
  "Super, 1, workspace, 1"
  "Super, 2, workspace, 2"
  "Super, 3, workspace, 3"
  "Super, 4, workspace, 4"
  "Super, 5, workspace, 5"
  "Super, 6, workspace, 6"
  "Super, 7, workspace, 7"
  "Super, 8, workspace, 8"
  "Super, 9, workspace, 9"
  "Super, 0, workspace, 10"
  "Ctrl+Super, Right, workspace, +1"
  "Ctrl+Super, Left, workspace, -1"
  "Super, mouse_up, workspace, +1"
  "Super, mouse_down, workspace, -1"
  "Ctrl+Super, mouse_up, workspace, +1"
  "Ctrl+Super, mouse_down, workspace, -1"
  "Super, Page_Down, workspace, +1"
  "Super, Page_Up, workspace, -1"
  "Ctrl+Super, Page_Down, workspace, +1"
  "Ctrl+Super, Page_Up, workspace, -1"
  "Super, S, togglespecialworkspace,"
  "Super, mouse:275, togglespecialworkspace,"

  # Workspace management
  "Super+Alt, 1, movetoworkspacesilent, 1"
  "Super+Alt, 2, movetoworkspacesilent, 2"
  "Super+Alt, 3, movetoworkspacesilent, 3"
  "Super+Alt, 4, movetoworkspacesilent, 4"
  "Super+Alt, 5, movetoworkspacesilent, 5"
  "Super+Alt, 6, movetoworkspacesilent, 6"
  "Super+Alt, 7, movetoworkspacesilent, 7"
  "Super+Alt, 8, movetoworkspacesilent, 8"
  "Super+Alt, 9, movetoworkspacesilent, 9"
  "Super+Alt, 0, movetoworkspacesilent, 10"
  "Ctrl+Super+Shift, Up, movetoworkspacesilent, special"
  "Ctrl+Super+Shift, Right, movetoworkspace, +1"
  "Ctrl+Super+Shift, Left, movetoworkspace, -1"
  "Ctrl+Super, BracketLeft, workspace, -1"
  "Ctrl+Super, BracketRight, workspace, +1"
  "Ctrl+Super, Up, workspace, -5"
  "Ctrl+Super, Down, workspace, +5"
  "Super+Shift, mouse_down, movetoworkspace, -1"
  "Super+Shift, mouse_up, movetoworkspace, +1"
  "Super+Alt, mouse_down, movetoworkspace, -1"
  "Super+Alt, mouse_up, movetoworkspace, +1"
  "Super+Alt, Page_Down, movetoworkspace, +1"
  "Super+Alt, Page_Up, movetoworkspace, -1"
  "Super+Shift, Page_Down, movetoworkspace, +1"
  "Super+Shift, Page_Up, movetoworkspace, -1"
  "Super+Alt, S, movetoworkspacesilent, special"
  "Super, P, pin"
  "Ctrl+Super, S, togglespecialworkspace,"
  "Alt, Tab, cyclenext"
  "Alt, Tab, bringactivetotop,"

  # Widgets
  "Ctrl+Super, R, exec, hyprpanel"
  "Ctrl+Super+Alt, R, exec, hyprctl reload; killall gjs; hyprpanel &"
  ''Super, Super_L, exec, pkill otter-launcher || ghostty --class="com.free.otter-launcher" --title="otter-launcher" -e otter-launcher''

  # Media
  ''Super+Shift, N, exec, playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`''
  "Super+Shift+Alt, mouse:275, exec, playerctl previous"
  ''Super+Shift+Alt, mouse:276, exec, playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`''
  "Super+Shift, B, exec, playerctl previous"
  "Super+Shift, P, exec, playerctl play-pause"

  # Apps
  "Super, T, exec, "
  "Super, Z, exec, Zed"
  "Super, C, exec, ghostty -e nvim"
  "Super, E, exec, ghostty -e yazi"
  "Super+Alt, E, exec, thunar"
  "Super, W, exec, zen"
  "Ctrl+Super, W, exec, firefox"
  "Super+Shift, W, exec, wps"
  ''Super, I, exec, XDG_CURRENT_DESKTOP="gnome" gnome-control-center''
  "Ctrl+Super, V, exec, pavucontrol"
  "Ctrl+Super+Shift, V, exec, easyeffects"
  "Ctrl+Shift, Escape, exec, gnome-system-monitor"
  "Ctrl+Super, Slash, exec, pkill anyrun || anyrun"
  "Super+Alt, Slash, exec, pkill anyrun || fuzzel"
  "Super+Shift, T, exec, AyuGram"
  "Super+Shift, D, exec, discord"
  "Super, S, exec, spotify-launcher"
  "Super, K, exec, ghostty -e calcure"

  # Cursed
  "Ctrl+Super, Backslash, resizeactive, exact 640 480"
]
