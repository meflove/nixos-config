{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      config,
      ...
    }: {
      sops = {
        secrets = lib.flattenSecrets {
          pass = {
            neededForUsers = true;
          };
        };
      };
      services = {
        getty = {
          autologinUser = lib.userName;
          autologinOnce = true;
        };
        userborn.enable = true;
      };

      users = {
        defaultUserShell =
          if config.programs.fish.enable
          then config.programs.fish.package
          else pkgs.bash;

        groups = {
          ${lib.userName} = {};
          media = {};
        };

        users = {
          ${lib.userName} = {
            hashedPasswordFile = config.sops.secrets.pass.path;

            home = "/home/" + lib.userName;
            createHome = true;

            openssh.authorizedKeys.keys = import ./ssh-keys.nix;

            extraGroups = [
              "audio"
              "input"
              "video"
              "users"

              "adbusers"
              "docker"
              "gamemode"
              "libvirtd"
              "kvm"
              "networkmanager"
              "podman"
              "wheel"

              # torrent
              "transmission"
            ];

            description = "nixos system user, owner of ${lib.hostName}!";
          };

          root = {
            initialHashedPassword = lib.mkForce null;
          };

          media = {
            isSystemUser = true;
            group = "media";
          };
        };
      };
    };
  };
}
