{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  super = "Super";
  term = lib.getExe config.programs.ghostty.package;
  editor = lib.getExe inputs.angeldust-nixCats.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
  [
    # Essentials
    "${super}, T, exec, ${term}"
    "${super}, Return, exec, ${term}"
    "${super}, Space, exec, true"

    # Actions
    ''${super}, V, exec, ${term} --class="com.free.clipse" --title="clipse" -e ${lib.getExe config.services.clipse.package}''
    "${super}, Period, exec, pkill smile || ${lib.getExe pkgs.smile}"
    ",Print, exec, ${lib.getExe pkgs.grimblast} -nf copy area"
    ''${super}+Ctrl,T,exec, ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} $SLURP_ARGS)" "tmp.png" && ${lib.getExe pkgs.tesseract} -l eng "tmp.png" - | wl-copy && rm "tmp.png"''
    ''${super}+Shift, C, exec, ${lib.getExe pkgs.hyprpicker} -ar''

    # Session
    "${super}, L, exec, ${lib.getExe config.programs.hyprlock.package}"

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
    ''${super}, Space, exec, pkill otter-launcher || ${term} --class="com.free.otter-launcher" --title="otter-launcher" -e ${lib.getExe pkgs.bash} -c "sleep 0.05 && ${lib.getExe inputs.otter-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default}"''

    # Apps
    "${super}, T, exec, "
    "Ctrl+Shift+${super}, T, exec, ${lib.getExe config.programs.kitty.package}"
    "${super}, C, exec, ${term} -e ${editor}"
    "${super}, E, exec, ${term} -e ${lib.getExe config.programs.yazi.package}"
    "${super}, W, exec, ${lib.getExe config.programs.zen-browser.package}"
    "Ctrl+${super}, V, exec, ${lib.getExe pkgs.pwvucontrol}"
    "${super}+Shift, T, exec, ${lib.getExe inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default}"
    "${super}+Shift, D, exec, Discord"
    ''${super}, G, exec, pkill kalker || ${term} --class="com.free.kalker" --title="kalker" -e ${lib.getExe pkgs.kalker}''
  ]
  ++ (
    # workspaces
    builtins.concatLists (builtins.genList (
        i: let
          ws =
            if i == 0
            then 10
            else i;
        in [
          "${super}, ${toString i}, workspace, ${toString ws}"
          "${super}+Alt, ${toString i}, movetoworkspacesilent, ${toString ws}"
        ]
      )
      10)
  )
