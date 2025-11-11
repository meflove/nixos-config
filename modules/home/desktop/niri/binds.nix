{
  lib,
  pkgs,
  ...
}: let
  super = "Super";
  term = "ghostty";
  editor = "nvim";
in {
  # Essentials
  "${super}+T".action.spawn = ["${term}"];
  "${super}+Return".action.spawn = ["${term}"];

  # Actions
  "${super}+V".action.spawn = ["${term}" "--class=com.free.clipse" "--title=clipse" "-e" "clipse"];
  "${super}+N".action.spawn = ["sh" "-c" "pkill tjournal || ${term} --class=com.note.tjournal --title=tjournal -e tjournal"];
  "${super}+Period".action.spawn = ["sh" "-c" "pkill smile || ${lib.getExe pkgs.smile}"];
  "Print".action.spawn = ["${lib.getExe pkgs.grimblast}" "-nf" "copy" "area"];
  "${super}+Ctrl+T".action.spawn = [
    "sh"
    "-c"
    "${lib.getExe pkgs.grim} -g \"${lib.getExe pkgs.slurp} $SLURP_ARGS\" \"tmp.png\" && ${lib.getExe pkgs.tesseract} -l eng \"tmp.png\" - | wl-copy && rm \"tmp.png\""
  ];
  "${super}+Shift+C".action.spawn = ["${lib.getExe pkgs.hyprpicker}" "-ar"];

  # Session
  "${super}+G".action.spawn = ["sh" "-c" "pkill kalker || ${term} --class=com.free.kalker --title=kalker -e kalker"];
  "${super}+L".action.spawn = ["hyprlock"];

  # Window management
  "${super}+Left".action.focus-column-left = {};
  "${super}+Right".action.focus-column-right = {};
  "${super}+Up".action.focus-window-up = {};
  "${super}+Down".action.focus-window-down = {};
  "${super}+BracketLeft".action.focus-column-left = {};
  "${super}+BracketRight".action.focus-column-right = {};
  "${super}+Q".action.close-window = {};
  "${super}+O".action.toggle-overview = {};

  # Window arrangement
  "${super}+Shift+Left".action.move-column-left = {};
  "${super}+Shift+Right".action.move-column-right = {};
  "${super}+Shift+Up".action.move-window-up = {};
  "${super}+Shift+Down".action.move-window-down = {};
  "${super}+Alt+Space".action.toggle-window-floating = {};
  "${super}+F".action.fullscreen-window = {};
  "${super}+D".action.maximize-column = {};

  # Workspace navigation
  "${super}+1".action.focus-workspace = 1;
  "${super}+2".action.focus-workspace = 2;
  "${super}+3".action.focus-workspace = 3;
  "${super}+4".action.focus-workspace = 4;
  "${super}+5".action.focus-workspace = 5;
  "${super}+6".action.focus-workspace = 6;
  "${super}+7".action.focus-workspace = 7;
  "${super}+8".action.focus-workspace = 8;
  "${super}+9".action.focus-workspace = 9;
  "${super}+0".action.focus-workspace = 10;

  # Workspace management
  "${super}+Alt+1".action.move-column-to-workspace = 1;
  "${super}+Alt+2".action.move-column-to-workspace = 2;
  "${super}+Alt+3".action.move-column-to-workspace = 3;
  "${super}+Alt+4".action.move-column-to-workspace = 4;
  "${super}+Alt+5".action.move-column-to-workspace = 5;
  "${super}+Alt+6".action.move-column-to-workspace = 6;
  "${super}+Alt+7".action.move-column-to-workspace = 7;
  "${super}+Alt+8".action.move-column-to-workspace = 8;
  "${super}+Alt+9".action.move-column-to-workspace = 9;
  "${super}+Alt+0".action.move-column-to-workspace = 10;
  "Ctrl+${super}+Shift+Right".action.move-window-to-workspace = "+1";
  "Ctrl+${super}+Shift+Left".action.move-window-to-workspace = "-1";
  "Ctrl+${super}+BracketLeft".action.focus-workspace = "-1";
  "Ctrl+${super}+BracketRight".action.focus-workspace = "+1";
  "Ctrl+${super}+Up".action.focus-workspace = "-5";
  "Ctrl+${super}+Down".action.focus-workspace = "+5";
  "${super}+Shift+WheelScrollDown".action.move-window-to-workspace = "-1";
  "${super}+Shift+WheelScrollUp".action.move-window-to-workspace = "+1";
  "${super}+Alt+WheelScrollDown".action.move-window-to-workspace = "-1";
  "${super}+Alt+WheelScrollUp".action.move-window-to-workspace = "+1";
  "${super}+Alt+Page_Down".action.move-window-to-workspace = "+1";
  "${super}+Alt+Page_Up".action.move-window-to-workspace = "-1";
  "${super}+Shift+Page_Down".action.move-window-to-workspace = "+1";
  "${super}+Shift+Page_Up".action.move-window-to-workspace = "-1";
  "Alt+Tab".action.focus-window-previous = {};

  # Widgets
  "${super}+Space" = {
    repeat = false;
    action.spawn = [
      "sh"
      "-c"
      "pkill otter-launcher || ${term} --class=com.free.otter-launcher --title=otter-launcher -e sh -c 'sleep 0.05 && otter-launcher'"
    ];
  };

  # Apps
  "Ctrl+Shift+${super}+T".action.spawn = ["kitty"];
  "${super}+C".action.spawn = ["${term}" "-e" "${editor}"];
  "${super}+E".action.spawn = ["${term}" "-e" "yazi"];
  "${super}+W".action.spawn = ["zen-beta"];
  "Ctrl+${super}+V".action.spawn = ["pavucontrol"];
  "${super}+Shift+T".action.spawn = ["AyuGram"];
  "${super}+Shift+D".action.spawn = ["discord"];
  "${super}+K".action.spawn = ["${term}" "-e" "calcure"];
}
