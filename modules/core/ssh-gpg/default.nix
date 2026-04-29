{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      pkgs,
      lib,
      ...
    }: {
      imports = [
        ./ssh-notifier.nix
      ];

      services = {
        openssh = {
          enable = true;
          ports = [2222];

          settings = {
            PasswordAuthentication = true;
            PermitRootLogin = "no";
          };

          extraConfig = ''
            PubkeyAuthentication yes
            KbdInteractiveAuthentication yes
          '';
        };

        fail2ban = {
          enable = true;
          bantime-increment.enable = true;
        };
      };

      environment = {
        systemPackages = lib.attrValues {
          inherit
            (pkgs)
            openssl
            ;
        };
      };

      hm = {
        sops = let
          secretSettings = {
            sopsFile = ../../../secrets/ssh/servers/hostoff.yaml;
          };
        in {
          secrets = lib.genAttrs [
            "hostname"
            "port"
            "user"
          ] (_: secretSettings);

          templates."hostoff" = {
            content = let
              ph = config.hm.sops.placeholder;
            in
              # ssh-config
              ''
                Host hostoff-vpn
                  HostName ${ph.hostname}
                  User ${ph.user}
                  Port ${ph.port}
                  identityFile ~/.ssh/id_ed25519
              '';
            path = "/home/${lib.userName}/.ssh/config.d/hostoff";
            mode = "0444";
          };
        };
        programs = {
          ssh = {
            enable = true;
            enableDefaultConfig = false;

            includes = [
              "config.d/*"
            ];
            matchBlocks = {
              "github.com" = {
                user = "meflove";
                identityFile = "~/.ssh/id_ed25519";
              };

              "*" = {
                forwardAgent = false;
                serverAliveInterval = 0;
                serverAliveCountMax = 3;
                compression = false;
                addKeysToAgent = "no";
                hashKnownHosts = false;
                userKnownHostsFile = "~/.ssh/known_hosts";
                controlMaster = "no";
                controlPath = "~/.ssh/master-%r@%n:%p";
                controlPersist = "no";
              };
            };
          };

          gpg = {
            enable = true;
          };
        };

        services = {
          gpg-agent = {
            enable = true;
            enableFishIntegration = true;
            enableNushellIntegration = true;

            defaultCacheTtl = 3600;
            maxCacheTtl = 7200;

            pinentry = {
              package = pkgs.pinentry-curses;
              program = "pinentry-curses";
            };
          };
          ssh-agent = {
            enable = true;
          };
        };
      };
    };
  };
}
