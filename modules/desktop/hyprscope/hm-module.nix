{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprscope;

  package = inputs.self.packages.${lib.hostPlatform}.hyprscope;
in {
  options.programs.hyprscope = {
    enable = lib.mkEnableOption "Enable hyprscope";

    gamescopeArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        List of arguments to pass to gamescope when launching hyprscope.
      '';
    };

    gamemodeIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to enable gamemode integration for hyprscope.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [
        package
      ]
      ++ lib.optionals cfg.gamemodeIntegration [pkgs.gamemode];

    xdg.configFile."hypr/hyprscope.conf" = {
      text =
        (
          # Автоматически добавляем -G при gamemodeIntegration
          lib.optionals cfg.gamemodeIntegration ["-G"]
          ++ cfg.gamescopeArgs
        )
        |> lib.concatStringsSep "\n";
    };
  };
}
