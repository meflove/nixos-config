{ pkgs, config, ... }:
{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;

    webHome = "${pkgs.flood-for-transmission}";
    settings = {
      download-dir = "${config.users.users.angeldust.home}/Torrents";
    };
  };

  environment.systemPackages = with pkgs; [
    rustmission
    flood-for-transmission
  ];
}
