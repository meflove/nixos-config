{
  inputs,
  pkgs,
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.desktop.dankMaterialShell;
in {
  options.${namespace}.nixos.desktop.dankMaterialShell = {
    enable =
      lib.mkEnableOption ''
        enable quickShell
      ''
      // {
        # default =
        #   inputs.self.homeConfigurations."angeldust@nixos-pc".config.home.${namespace}.desktop.hyprland.enable;
        default = true;
      };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        wl-clipboard
        gtk3
        gtk4
        jq
      ];
    };

    programs.dms-shell = {
      enable = true;
      package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;

      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true;
      };

      enableVPN = false;
      enableDynamicTheming = false;

      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)
    };
  };
}
