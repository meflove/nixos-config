{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.desktop.flatpak;
in {
  options.${namespace}.nixos.desktop.flatpak = {
    enable =
      lib.mkEnableOption "enable Flatpak"
      // {
        default = false;
      };
    flatpakPackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of Flatpak packages to install.";
    };
  };

  config = mkIf cfg.enable {
    services.flatpak = {
      enable = true;

      packages = cfg.flatpakPackages;
    };
  };
}
