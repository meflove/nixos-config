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
        webHome = pkgs.flood-for-transmission;

        performanceNetParameters = true;
        openPeerPorts = true;
        openRPCPort = true;

        home = "/home/${lib.userName}/Torrents";
        downloadDirPermissions = "777";

        settings = {
          watch-dir-enabled = true;
          trash-original-torrent-files = true;

          download-dir = "${config.services.transmission.home}";
          watch-dir = "${config.services.transmission.home}/torrent_files";
        };
      };

      users.users.${lib.userName}.extraGroups = [
        # torrent
        config.services.transmission.group
      ];
    };
  };
}
