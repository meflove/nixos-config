{config, ...}: let
  secretSettings = {
    sopsFile = ../../../secrets/ssh/angeldust.yaml;
  };
in {
  sops = {
    secrets = {
      angl_ssh_priv =
        secretSettings
        // {
          path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        };
      angl_ssh_pub =
        secretSettings
        // {
          path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        };
    };
  };
}
