{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      services.transmission = {
        enable = true;
        package = pkgs.transmission_4;
        webHome = "${pkgs.flood-for-transmission}";

        home = "/home/${lib.userName}/Torrents";
        downloadDirPermissions = "777";

        settings = {
          download-dir = "${config.services.transmission.home}";

          watch-dir-enabled = true;
          trash-original-torrent-files = true;
          watch-dir = "${config.services.transmission.home}/torrent_files";
        };
      };
    };
  };
}
