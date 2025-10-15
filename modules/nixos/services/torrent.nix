{
  pkgs,
  config,
  ...
}: {
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    webHome = "${pkgs.flood-for-transmission}";

    home = "${config.users.users.angeldust.home}/Torrents";
    downloadDirPermissions = "777";

    settings = {
      download-dir = "${config.services.transmission.home}";

      watch-dir-enabled = true;
      trash-original-torrent-files = true;
      watch-dir = "${config.services.transmission.home}/torrent_files";
    };
  };

  environment.systemPackages = with pkgs; [
    rustmission
    deluge
  ];
}
