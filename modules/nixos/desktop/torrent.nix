{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.desktop.torrent;
in {
  options.${namespace}.nixos.desktop.torrent = {
    enable =
      lib.mkEnableOption "enable torrent client and services"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    users.users.angeldust.extraGroups = ["transmission"];

    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;
      webHome = "${pkgs.flood-for-transmission}";

      home = "${config.users.users.angeldust.home}/Torrents";

      settings = {
        download-dir = "${config.services.transmission.home}";

        watch-dir-enabled = true;
        trash-original-torrent-files = true;
        watch-dir = "${config.services.transmission.home}/torrent_files";
      };
    };
  };
}
