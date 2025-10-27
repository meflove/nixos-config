{
  pkgs,
  inputs,
  lib,
  config,
  namespace,
  system,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.xdg;
in {
  options.${namespace}.home.desktop.xdg = {
    enable =
      lib.mkEnableOption "enable XDG user directories and mimeapps configuration"
      // {
        default = config.${namespace}.home.desktop.hyprland.enable;
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
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
        xdgOpenUsePortal = true;
      };

      mimeApps = {
        enable = true;

        defaultApplications = {
          "image/jpeg" = ["imv.desktop"];
          "image/png" = ["imv.desktop"];
          "inode/directory" = [
            "${config.programs.yazi.package}/share/applications/yazi.desktop"
          ];
          "x-scheme-handler/http" = ["zen-beta.desktop"];
          "x-scheme-handler/https" = ["zen-beta.desktop"];
          "x-scheme-handler/chrome" = ["zen-beta.desktop"];
          "text/html" = ["zen-beta.desktop"];
          "application/x-extension-htm" = ["zen-beta.desktop"];
          "application/x-extension-html" = ["zen-beta.desktop"];
          "application/x-extension-shtml" = ["zen-beta.desktop"];
          "application/xhtml+xml" = ["zen-beta.desktop"];
          "application/x-extension-xhtml" = ["zen-beta.desktop"];
          "application/x-extension-xht" = ["zen-beta.desktop"];

          "x-scheme-handler/tg" = [
            "${
              inputs.ayugram-desktop.packages.${system}.ayugram-desktop
            }/share/applications/com.ayugram.desktop.desktop"
          ];
          "x-scheme-handler/tonsite" = [
            "${
              inputs.ayugram-desktop.packages.${system}.ayugram-desktop
            }/share/applications/com.ayugram.desktop.desktop"
          ];
          "x-scheme-handler/discord" = ["discord.desktop"];
        };

        associations.added = {
          "image/jpeg" = ["imv.desktop"];
          "image/png" = ["imv.desktop"];
          "inode/directory" = ["${config.programs.yazi.package}/share/applications/yazi.desktop"];

          "x-scheme-handler/http" = ["zen-beta.desktop"];
          "x-scheme-handler/https" = ["zen-beta.desktop"];
          "x-scheme-handler/chrome" = ["zen-beta.desktop"];
          "text/html" = ["zen-beta.desktop"];
          "application/x-extension-htm" = ["zen-beta.desktop"];
          "application/x-extension-html" = ["zen-beta.desktop"];
          "application/x-extension-shtml" = ["zen-beta.desktop"];
          "application/xhtml+xml" = ["zen-beta.desktop"];
          "application/x-extension-xhtml" = ["zen-beta.desktop"];
          "application/x-extension-xht" = ["zen-beta.desktop"];

          "x-scheme-handler/tg" = ["com.ayugram.desktop.desktop"];
          "x-scheme-handler/tonsite" = ["com.ayugram.desktop.desktop"];
        };
      };
    };
  };
}
