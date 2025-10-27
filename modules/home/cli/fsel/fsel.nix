{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.cli.fsel;
in {
  imports = [./hm-module.nix];

  options.${namespace}.home.cli.fsel = {
    enable =
      lib.mkEnableOption "enable fsel, a application launcher"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    programs.fsel = {
      enable = false;

      settings = {
        terminal_launcher = "ghostty -e";
      };
    };
  };
}
