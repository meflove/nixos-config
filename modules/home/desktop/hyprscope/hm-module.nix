{
  inputs,
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.programs.hyprscope;

  package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.hyprscope;
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
    assertions = [
      {
        assertion = config.home.${namespace}.desktop.hyprland.enable;
        message = "hyprscope requires hyprland to be enabled via home.${namespace}.desktop.hyprland.enable";
      }
    ];

    home.packages =
      [
        package
      ]
      ++ lib.optionals cfg.gamemodeIntegration [pkgs.gamemode];

    xdg.configFile."hypr/hyprscope.conf" = {
      text = lib.concatStringsSep "\n" (
        # Автоматически добавляем -G при gamemodeIntegration
        (lib.optionals cfg.gamemodeIntegration ["-G"])
        ++ cfg.gamescopeArgs
      );
    };
  };
}
