{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.security;
in {
  options.${namespace}.nixos.core.security = {
    enable =
      lib.mkEnableOption "Enable security settings such as sudo-rs."
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    security = {
      sudo.enable = false;

      sudo-rs = {
        enable = true;

        execWheelOnly = true;
        wheelNeedsPassword = true;
        extraRules = [
          {
            commands = [
              {
                command = "/run/current-system/sw/bin/nixos-rebuild";
                options = ["NOPASSWD"];
              }
              {
                command = "/run/current-system/sw/bin/nh";
                options = ["NOPASSWD"];
              }
            ];
            groups = ["wheel"];
          }
        ];
      };
    };
  };
}
