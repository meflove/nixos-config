{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  super = "Super";
  shift = "Shift";
  alt = "Alt";

  term = lib.getExe config.hm.programs.ghostty.package;

  spawn-sh = cmd: {
    spawn = ["sh" "-c" cmd];
  };

  msg = cmd: spawn-sh "niri msg action ${cmd}";

  jq = lib.getExe pkgs.jq;

  toggleApp = pkg: appId: title:
    (pkgs.writeShellScriptBin "${title}-toggle-niri" ''
      TERMINAL=${term}

      if [[ -z $(niri msg windows | grep 'Title: "${title}"') ]]
      then
        $TERMINAL --class=${appId} --title=${title} -e sh -c 'sleep 0.02 && ${lib.getExe pkg}';
      else
          if [[ -z $(niri msg -j windows | ${jq} '.[] | select(.is_focused==true).app_id' | ${lib.getExe pkgs.ripgrep} ${appId}) ]];
        then
          niri msg action focus-window --id $(niri msg -j windows | ${jq} ".[] | select(.app_id==\"${appId}\").id");
        else
          niri msg action close-window;
          fi
      fi
    '')
    |> lib.getExe;

  names = ["telegram" "browser" "cli" "games"];

  workspaceBinds =
    names
    |> lib.imap1 (i: name: [
      {
        name = "${super}+${toString i}";
        value.action.focus-workspace = name;
      }
      {
        name = "${super}+Alt+${toString i}";
        value.action.move-column-to-workspace = name;
      }
    ])
    |> lib.concatLists
    |> lib.listToAttrs;
in
  workspaceBinds
  // {
    # ====================
    # Essentials
    # ====================
    "${super}+T".action.spawn = ["${term}"];
    "${super}+Return".action.spawn = ["${term}"];

    # ====================
    # Actions
    # ====================
    "${super}+V" = {
      repeat = false;
      action.spawn = "${toggleApp config.hm.services.clipse.package "com.free.clipse" "clipse"}";
    };
    "${super}+G" = {
      repeat = false;
      action.spawn = "${toggleApp pkgs.nasctui "com.free.nasctui" "nasctui"}";
    };

    "${super}+Space" = {
      repeat = false;
      action.spawn = "${toggleApp inputs.otter-launcher.packages.${lib.hostPlatform}.default "com.free.otter-launcher" "otter-launcher"}";
    };

    "${super}+Ctrl+L".action.spawn = ["hyprlock"];

    # Screenshots
    "Print".action = msg "screenshot -p false";
    "${shift}+Print".action = msg "screenshot-screen -p false";
    "${alt}+Print".action = msg "screenshot-window -p false";

    "${super}+Ctrl+T".action =
      spawn-sh
      ''${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} $SLURP_ARGS)" "tmp.png" && ${lib.getExe pkgs.tesseract} -l "rus+eng" "tmp.png" - | wl-copy && rm "tmp.png"'';
    "${super}+Ctrl+C".action.spawn = ["${lib.getExe pkgs.hyprpicker}" "-ar"];

    # ====================
    # Window management
    # ====================
    "${super}+Q".action.close-window = {};
    "${super}+O".action.toggle-overview = {};

    "${super}+Left".action.focus-column-left = {};
    "${super}+Right".action.focus-column-right = {};
    "${super}+Up".action.focus-window-up = {};
    "${super}+Down".action.focus-window-down = {};
    "${super}+H".action.focus-column-left = {};
    "${super}+J".action.focus-window-down = {};
    "${super}+K".action.focus-window-up = {};
    "${super}+L".action.focus-column-right = {};

    # ====================
    # Window arrangement
    # ====================
    "${super}+Shift+Left".action.move-column-left = {};
    "${super}+Shift+Right".action.move-column-right = {};
    "${super}+Shift+Up".action.move-window-up = {};
    "${super}+Shift+Down".action.move-window-down = {};
    "${super}+Shift+H".action.move-column-left = {};
    "${super}+Shift+J".action.move-window-down = {};
    "${super}+Shift+K".action.move-window-up = {};
    "${super}+Shift+L".action.move-column-right = {};

    "${super}+Alt+Space".action.toggle-window-floating = {};
    "${super}+F".action.fullscreen-window = {};
    "${super}+D".action.maximize-column = {};

    # Column/Window width
    "${super}+S".action.switch-preset-column-width = {};
    "${super}+Minus".action.set-column-width = "-10%";
    "${super}+Equal".action.set-column-width = "+10%";

    # Consume/Expel windows
    "${super}+Comma".action.consume-window-into-column = {};
    "${super}+Period".action.expel-window-from-column = {};

    # ====================
    # Workspace navigation
    # ====================
    # Workspace scroll
    "${super}+WheelScrollDown" = {
      cooldown-ms = 150;
      action.focus-workspace-down = {};
    };
    "${super}+WheelScrollUp" = {
      cooldown-ms = 150;
      action.focus-workspace-up = {};
    };

    # ====================
    # Workspace management
    # ====================
    "${super}+Ctrl+Shift+Right".action.move-window-to-workspace = "+1";
    "${super}+Ctrl+Shift+Left".action.move-window-to-workspace = "-1";
    "${super}+Ctrl+BracketLeft".action.focus-workspace = "-1";
    "${super}+Ctrl+BracketRight".action.focus-workspace = "+1";
    "${super}+Ctrl+Up".action.focus-workspace = "-5";
    "${super}+Ctrl+Down".action.focus-workspace = "+5";

    "Alt+Tab".action.focus-window-previous = {};

    # ====================
    # Apps
    # ====================
    "${super}+W".action.spawn = lib.getExe config.hm.programs.zen-browser.package;
    "${super}+Ctrl+V".action.spawn = lib.getExe pkgs.pwvucontrol;
    "${super}+Shift+M".action.spawn = lib.getExe inputs.self.packages.${lib.hostPlatform}.soundcloud-desktop;
    "${super}+Shift+T".action.spawn = lib.getExe inputs.ayugram-desktop.packages.${lib.hostPlatform}.default;
    "${super}+Shift+D".action.spawn = ["equibop"];

    # ====================
    # Media keys
    # ====================
    "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
    "XF86AudioMicMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
    "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+"];
    "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%-"];

    # ====================
    # Help
    # ====================
    "${super}+Shift+Slash".action.show-hotkey-overlay = {};
  }
