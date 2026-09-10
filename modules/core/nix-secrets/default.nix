{
  flake-file.inputs = {
    nix-secrets.url = "github:unnamed-systems/nix-secrets";
  };
  flake = _: {
    nixosModules.${baseNameOf ./.} = {lib, ...}: {
      security.nix-secrets = {
        enable = true;

        storagePath = "${lib.flakeDir}/nix-secrets";
        storage = ../../../nix-secrets;
        identityPaths = [
          "/var/lib/nix-secrets/key.txt"
          "/etc/ssh/ssh_host_ed25519_key"
          "/home/${lib.userName}/.config/nix-secrets/age/keys.txt"
          "/home/${lib.userName}/.ssh/id_ed25519"
        ];

        recipientAliases = {
          angeldust = "age1hwfdncsemngkf4ekvpfegpgyt6z9ktc6pkxcsaq79shr72n4gg0sxeyrpa";
          nixos-pc = "age1v9ywaj5zwsxncha5ylh8semx33qhq0ygr4ur7k39q70nd7medd9qp2e6l9";
        };
        defaultRecipients = [
          "nixos-pc"
          "angeldust"
        ];
      };
    };
  };
}
