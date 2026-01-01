{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.cli.fsel;
in {
  imports = [./hm-module.nix];

  options.home.${namespace}.cli.fsel = {
    enable =
      lib.mkEnableOption "enable fsel, a application launcher"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    programs.fsel = {
      enable = true;

      settings = {
        terminal_launcher = "ghostty -e";
      };
    };
  };
}
