{
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
  };
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      pkgs,
      ...
    }: let
      sops-update-keys =
        pkgs.writeShellScriptBin "sops-update-keys"
        # bash
        ''
          for file in $(${lib.getExe pkgs.gnugrep} -lr "sops:" secrets/); do ${lib.getExe pkgs.sops} updatekeys -y $file; done
        '';
    in {
      config = {
        sops = {
          defaultSopsFile = ../../../secrets/secrets.yaml;
          age = {
            sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
            keyFile = "/var/lib/sops-nix/key.txt";
            generateKey = true;
          };
        };

        environment.systemPackages = [sops-update-keys pkgs.sops];

        hm = {
          sops = let
            secretSettings = {
              sopsFile = ../../../secrets/ssh-gpg/hosts/${lib.userName}-ssh.yaml;
            };
          in {
            age.sshKeyPaths = ["/home/${lib.userName}/.ssh/id_ed25519"];
            defaultSopsFile = ../../../secrets/secrets.yaml;
            secrets =
              lib.genAttrs [
                "angl_ssh_priv"
                "angl_ssh_pub"
              ]
              (_: secretSettings);
          };
        };
      };
    };
  };
}
