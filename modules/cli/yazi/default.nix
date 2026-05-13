{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      config,
      ...
    }: {
      hm = {
        programs.yazi =
          {
            enable = true;
            enableFishIntegration = true;
            enableNushellIntegration = true;
            # package = inputs.yazi.packages.${lib.hostPlatform}.default;

            extraPackages = lib.attrValues {
              inherit
                (pkgs)
                djvulibre
                ffmpegthumbnailer
                glow
                imagemagick
                jq
                p7zip-rar
                transmission_4
                wl-clipboard
                ouch
                ;
            };
          }
          // (import ./settings/main.nix {
            inherit
              pkgs
              lib
              config
              ;
          });

        xdg.mimeApps = {
          defaultApplications = {
            "inode/directory" = ["yazi.desktop"];
            "inode/mount-point" = ["yazi.desktop"];
          };
        };
      };
    };
  };
}
