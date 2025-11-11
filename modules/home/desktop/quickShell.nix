{
  pkgs,
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.quickShell;
in {
  options.${namespace}.home.desktop.quickShell = {
    enable =
      lib.mkEnableOption ''
        enable quickShell
      ''
      // {default = true;};
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        wl-clipboard
        gtk3
        gtk4
        jq
      ];
    };

    programs.dankMaterialShell = {
      enable = true;
      systemd = {
        enable = true; # Systemd service for auto-start
      };

      enableClipboard = false; # Clipboard history manager
      enableVPN = false;
      enableBrightnessControl = false;
      enableDynamicTheming = false;

      enableColorPicker = true; # Color picker tool
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)
      enableSystemSound = false; # System sound effects
    };
  };
}
