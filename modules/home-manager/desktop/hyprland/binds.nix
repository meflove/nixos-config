{inputs, ...}: let
  super = "Super";
  term = "ghostty";
  editor = "nvim";
in [
  # Essentials
  "${super}, T, exec, ${term}"
  "${super}, Return, exec, ${term}"
  ", ${super}, exec, true"

  # Actions
  ''${super}, V, exec, ${term} --class="com.free.clipse" --title="clipse" -e clipse''
  "${super}, Period, exec, pkill smile || smile"
  ",Print, exec, ${inputs.self}/scripts/grimblast.sh --freeze copy area"
  ''${super}+Ctrl,T,exec, grim -g "$(slurp $SLURP_ARGS)" "tmp.png" && tesseract -l eng "tmp.png" - | wl-copy && rm "tmp.png"''
  "${super}+Shift, C, exec, hyprpicker -ar"

  # Session
  ''${super}, G, exec, pkill kalker || ${term} --class="com.free.kalker" --title="kalker" -e kalker''
  "${super}, L, exec, hyprlock"

  # Window management
  "${super}, Left, movefocus, l"
  "${super}, Right, movefocus, r"
  "${super}, Up, movefocus, u"
  "${super}, Down, movefocus, d"
  "${super}, BracketLeft, movefocus, l"
  "${super}, BracketRight, movefocus, r"
  "${super}, Q, killactive,"

  # Window arrangement
  "${super}+Shift, Left, movewindow, l"
  "${super}+Shift, Right, movewindow, r"
  "${super}+Shift, Up, movewindow, u"
  "${super}+Shift, Down, movewindow, d"
  "${super}, Minus, splitratio, -0.1"
  "${super}, Equal, splitratio, +0.1"
  "${super}, Semicolon, splitratio, -0.1"
  "${super}, Apostrophe, splitratio, +0.1"
  "${super}+Alt, Space, togglefloating,"
  "${super}+Alt, F, fullscreenstate, 0 3"
  "${super}, F, fullscreen, 0"
  "${super}, D, fullscreen, 1"

  # Workspace navigation
  "${super}, 1, workspace, 1"
  "${super}, 2, workspace, 2"
  "${super}, 3, workspace, 3"
  "${super}, 4, workspace, 4"
  "${super}, 5, workspace, 5"
  "${super}, 6, workspace, 6"
  "${super}, 7, workspace, 7"
  "${super}, 8, workspace, 8"
  "${super}, 9, workspace, 9"
  "${super}, 0, workspace, 10"
  "Ctrl+${super}, Right, workspace, +1"
  "Ctrl+${super}, Left, workspace, -1"
  "${super}, mouse_up, workspace, +1"
  "${super}, mouse_down, workspace, -1"
  "Ctrl+${super}, mouse_up, workspace, +1"
  "Ctrl+${super}, mouse_down, workspace, -1"
  "${super}, Page_Down, workspace, +1"
  "${super}, Page_Up, workspace, -1"
  "Ctrl+${super}, Page_Down, workspace, +1"
  "Ctrl+${super}, Page_Up, workspace, -1"
  "${super}, S, togglespecialworkspace,"
  "${super}, mouse:275, togglespecialworkspace,"

  # Workspace management
  "${super}+Alt, 1, movetoworkspacesilent, 1"
  "${super}+Alt, 2, movetoworkspacesilent, 2"
  "${super}+Alt, 3, movetoworkspacesilent, 3"
  "${super}+Alt, 4, movetoworkspacesilent, 4"
  "${super}+Alt, 5, movetoworkspacesilent, 5"
  "${super}+Alt, 6, movetoworkspacesilent, 6"
  "${super}+Alt, 7, movetoworkspacesilent, 7"
  "${super}+Alt, 8, movetoworkspacesilent, 8"
  "${super}+Alt, 9, movetoworkspacesilent, 9"
  "${super}+Alt, 0, movetoworkspacesilent, 10"
  "Ctrl+${super}+Shift, Right, movetoworkspace, +1"
  "Ctrl+${super}+Shift, Left, movetoworkspace, -1"
  "Ctrl+${super}, BracketLeft, workspace, -1"
  "Ctrl+${super}, BracketRight, workspace, +1"
  "Ctrl+${super}, Up, workspace, -5"
  "Ctrl+${super}, Down, workspace, +5"
  "${super}+Shift, mouse_down, movetoworkspace, -1"
  "${super}+Shift, mouse_up, movetoworkspace, +1"
  "${super}+Alt, mouse_down, movetoworkspace, -1"
  "${super}+Alt, mouse_up, movetoworkspace, +1"
  "${super}+Alt, Page_Down, movetoworkspace, +1"
  "${super}+Alt, Page_Up, movetoworkspace, -1"
  "${super}+Shift, Page_Down, movetoworkspace, +1"
  "${super}+Shift, Page_Up, movetoworkspace, -1"
  "${super}+Alt, S, movetoworkspacesilent, special"
  "${super}, P, pin"
  "Ctrl+${super}, S, togglespecialworkspace,"
  "Alt, Tab, cyclenext"
  "Alt, Tab, bringactivetotop,"

  # Widgets
  ''${super}, Super_L, exec, pkill otter-launcher || ${term} --class="com.free.otter-launcher" --title="otter-launcher" -e sh -c "sleep 0.05 && otter-launcher"''

  # Apps
  "${super}, T, exec, "
  "Ctrl+Shift+${super}, T, exec, kitty"
  "${super}, C, exec, ${term} -e ${editor}"
  "${super}, E, exec, ${term} -e yazi"
  "${super}, W, exec, zen-beta"
  "Ctrl+${super}, V, exec, pavucontrol"
  "${super}+Shift, T, exec, AyuGram"
  "${super}+Shift, D, exec, discord"
  "${super}, S, exec, spotify-launcher"
  "${super}, K, exec, ${term} -e calcure"
]
