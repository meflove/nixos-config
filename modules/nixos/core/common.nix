{
  inputs,
  lib,
  namespace,
  config,
  system,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.common;
in {
  options.${namespace}.nixos.core.common = {
    enable = lib.mkEnableOption "Enable common core settings and programs for all hosts." // {default = true;};
  };

  config = mkIf cfg.enable {
    # Общие системные программы и настройки для всех хостов
    programs = {
      xwayland.enable = true;
      hyprland = {
        enable = true;
        # set the flake package
        package = inputs.hyprland.packages.${system}.hyprland;
        # # make sure to also set the portal package, so that they are in sync
        portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
      };
      # Включение fish на системном уровне
      fish.enable = true;

      dconf.enable = true;

      nh = {
        enable = true;
        package = inputs.nh.packages.${system}.default;

        flake = "/home/angeldust/.config/nixos-config"; # sets NH_OS_FLAKE variable for you

        clean = {
          enable = true;

          dates = "daily";
          extraArgs = "--delete-older-than 7d";
        };
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
