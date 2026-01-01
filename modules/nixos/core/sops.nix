{
  pkgs,
  lib,
  ...
}: let
  sops-update-keys = pkgs.writeShellScriptBin "sops-update-keys" ''
    for file in $(${lib.getExe pkgs.gnugrep} -lr "sops:"); do ${lib.getExe pkgs.sops} updatekeys -y $file; done
  '';
in {
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  environment.systemPackages = [sops-update-keys pkgs.sops];
}
