{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.desktop.screenRecord;
in {
  options.${namespace}.nixos.desktop.screenRecord = {
    enable =
      lib.mkEnableOption "enable GPU-accelerated screen recording tools"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    programs.gpu-screen-recorder.enable = true; # For promptless recording on both CLI and GUI

    environment.systemPackages = with pkgs; [
      gpu-screen-recorder-gtk # GUI app
    ];
  };
}
