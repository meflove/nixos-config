{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.gaming;
in {
  options.${namespace}.home.desktop.gaming = {
    enable =
      lib.mkEnableOption "enable gaming optimizations and tools"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      protonup-ng
    ];

    home.sessionVariables = {
      STEAM_COMPAT_TOOLS_PATH = "\${HOME}/.steam/root/compatibilitytools.d";
    };

    programs.mangohud = {
      enable = true;

      settings = {
        winesync = true;

        full = true;
      };
    };
  };
}
