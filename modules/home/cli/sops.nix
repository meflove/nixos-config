{config, ...}: {
  sops = {
    # age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    defaultSopsFile = ../../../secrets/secrets.yaml;
  };
}
