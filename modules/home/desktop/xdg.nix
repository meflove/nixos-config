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
        default = config.home.${namespace}.desktop.hyprland.enable;
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
          xdg-desktop-portal-gnome
        ];
        xdgOpenUsePortal = true;
      };

      mimeApps = let
        value = let
          zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta; # or twilight
        in
          zen-browser.meta.desktopFileName;
        associations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]);
      in {
        enable = true;

        associations.added =
          associations
          // {
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

        defaultApplications =
          associations
          // {
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
