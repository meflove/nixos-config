{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      config,
      ...
    }: {
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
    };
  };
}
