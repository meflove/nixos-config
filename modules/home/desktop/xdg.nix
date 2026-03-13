{
  pkgs,
  inputs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.desktop.xdg;
in {
  options.home.${namespace}.desktop.xdg = {
    enable =
      lib.mkEnableOption "enable XDG user directories and mimeapps configuration"
      // {
        default = config.home.${namespace}.desktop.hyprland.enable || config.home.${namespace}.desktop.niri.enable;
      };
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      mime.enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;
      };

      portal = {
        xdgOpenUsePortal = true;
      };

      mimeApps = {
        enable = true;

        associations.added = {
          "image/jpeg" = ["imv.desktop"];
          "image/png" = ["imv.desktop"];
          "inode/directory" = ["${config.programs.yazi.package}/share/applications/yazi.desktop"];

          "x-scheme-handler/tg" = [
            "${
              inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.ayugram-desktop
            }/share/applications/com.ayugram.desktop.desktop"
          ];
          "x-scheme-handler/tonsite" = [
            "${
              inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.ayugram-desktop
            }/share/applications/com.ayugram.desktop.desktop"
          ];

          "x-scheme-handler/discord" = ["discord.desktop"];
        };

        defaultApplications = {
          "image/jpeg" = ["imv.desktop"];
          "image/png" = ["imv.desktop"];
          "inode/directory" = [
            "${config.programs.yazi.package}/share/applications/yazi.desktop"
          ];

          "x-scheme-handler/tg" = [
            "${
              inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.ayugram-desktop
            }/share/applications/com.ayugram.desktop.desktop"
          ];
          "x-scheme-handler/tonsite" = [
            "${
              inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.ayugram-desktop
            }/share/applications/com.ayugram.desktop.desktop"
          ];

          "x-scheme-handler/discord" = ["discord.desktop"];
        };
      };
    };
  };
}
