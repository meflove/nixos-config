{
  pkgs,
  inputs,
  lib,
  namespace,
  config,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.base-settings;
in {
  options.${namespace}.nixos.core.base-settings = {
    enable = lib.mkEnableOption "Enable base settings for all hosts (locale, timezone, shell)." // {default = true;};
  };

  config = mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;
        package = pkgs.fish;
      };

      dconf.enable = true;

      xwayland.enable = true;
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    };

    time.timeZone = "Asia/Barnaul";

    i18n = {
      extraLocales = [
        "en_US.UTF-8/UTF-8"
        "ru_RU.UTF-8/UTF-8"
      ];

      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_MESSAGES = "en_US.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };
    };
  };
}
