{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.development.direnv;
in {
  options.${namespace}.home.development.direnv = {
    enable =
      lib.mkEnableOption "enable direnv for managing per-project environment variables"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      silent = true;
      config = {
        global = {
          strict_env = true;
          warn_timeout = "2m";
          hide_env_diff = true;
        };
      };
    };

    home.packages = with pkgs; [
      devenv
    ];
  };
}
