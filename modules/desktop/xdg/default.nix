{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      environment.sessionVariables.TERMINAL = lib.getExe config.hm.programs.kitty.package;
      xdg = {
        portal = {
          enable = true;
          wlr.enable = true;
          xdgOpenUsePortal = true;
        };
      };
      hm = {
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

          terminal-exec = {
            enable = true;
            package = pkgs.xdg-terminal-exec;

            settings = {
              default = [
                "kitty.desktop"
                "ghostty.desktop"
              ];
            };
          };

          mimeApps = {
            enable = true;

            associations.added = config.hm.xdg.mimeApps.defaultApplications;
            defaultApplications = let
              mkMime = assocs:
                lib.pipe assocs [
                  (lib.mapAttrsToList (
                    prog:
                      map (type: {
                        "${type}" = prog;
                      })
                  ))
                  lib.flatten
                  lib.zipAttrs
                ];
            in
              mkMime {
                "mpv.desktop" = [
                  "audio/*"
                  "video/*"
                ];
                "imv-dir.desktop" = [
                  "image/*"
                  "image/gif"
                  "image/jpeg"
                  "image/png"
                  "image/webp"
                ];

                "yazi.desktop" = [
                  "inode/directory"
                ];

                "nvimWrap.desktop" = [
                  "text/plain"
                  "text/markdown"
                  "text/x-toml"
                  "application/x-wine-extension-ini"
                ];

                "com.ayugram.desktop.desktop" = [
                  "x-scheme-handler/tg"
                  "x-scheme-handler/tonsite"
                ];

                "discord.desktop" = [
                  "x-scheme-handler/discord"
                ];
              };
          };
        };
      };
    };
  };
}
