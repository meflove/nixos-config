{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.pipewire-soundpad;

  package = pkgs.angeldust-pkgs.pipewire-soundpad;
in {
  options.programs.pipewire-soundpad = {
    enable = lib.mkEnableOption "Enable pipewire-soundpad";
  };

  config = lib.mkIf cfg.enable {
    hm = {
      home.packages = [
        package
      ];

      systemd.user.services.pipewire-soundpad = {
        Unit = {
          Description = "Pipewire Soundpad Daemon";
          After = ["pipewire.service"];
        };

        Service = {
          ExecStart = "${package}/bin/pwsp-daemon";
          Restart = "no";
          RuntimeDirectory = "pwsp";
        };

        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };
}
