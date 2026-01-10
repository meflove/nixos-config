{
  pkgs,
  inputs,
  lib,
  namespace,
  config,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.common;
in {
  options.${namespace}.nixos.core.common = {
    enable = lib.mkEnableOption "Enable common core settings and programs for all hosts." // {default = true;};
  };

  config = mkIf cfg.enable {
    programs = {
      fish.enable = true;

      dconf.enable = true;

      xwayland.enable = true;
      hyprland = {
        enable = true;
        # set the flake package
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        # inherit (inputs.self.homeConfigurations."angeldust@nixos-pc".config.wayland.windowManager.hyprland) package;
        # # make sure to also set the portal package, so that they are in sync
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        # inherit (inputs.self.homeConfigurations."angeldust@nixos-pc".config.wayland.windowManager.hyprland) portalPackage;
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
