{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.cli.atuin;
in {
  options.${namespace}.home.cli.atuin = {
    enable =
      lib.mkEnableOption "enable the Atuin shell history manager"
      // {
        default = config.${namespace}.home.cli.fishShell.enable;
      };
  };

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        auto_sync = false;

        timezone = "+7";
        dialect = "uk";

        enter_accept = true;
        search_mode = "fuzzy";

        style = "full";

        common_subcommands = [
          "git"
          "ip"
          "systemctl"
          "nix"
        ];
        ignored_commands = [
          "c"
        ];
      };
    };
  };
}
