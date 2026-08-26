{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
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

          knownHosts = {
            "github.com" = {
              publicKeyFile = pkgs.writeText "github.keys" ''
                # github
                github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=

                github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=

                github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
              '';
            };
            "codeberg.com" = {
              publicKeyFile = pkgs.writeText "codeberg.keys" ''
                # codeberg
                codeberg.org ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8hZi7K1/2E2uBX8gwPRJAHvRAob+3Sn+y2hxiEhN0buv1igjYFTgFO2qQD8vLfU/HT/P/rqvEeTvaDfY1y/vcvQ8+YuUYyTwE2UaVU5aJv89y6PEZBYycaJCPdGIfZlLMmjilh/Sk8IWSEK6dQr+g686lu5cSWrFW60ixWpHpEVB26eRWin3lKYWSQGMwwKv4LwmW3ouqqs4Z4vsqRFqXJ/eCi3yhpT+nOjljXvZKiYTpYajqUC48IHAxTWugrKe1vXWOPxVXXMQEPsaIRc2hpK+v1LmfB7GnEGvF1UAKnEZbUuiD9PBEeD5a1MZQIzcoPWCrTxipEpuXQ5Tni4mN

                codeberg.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL2pDxWr18SoiDJCGZ5LmxPygTlPu+cCKSkpqkvCyQzl5xmIMeKNdfdBpfbCGDPoZQghePzFZkKJNR/v9Win3Sc=

                codeberg.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVIC02vnjFyL+I4RHfvIGNtOgJMe769VTF1VR4EB3ZB
              '';
            };
            "tangled.org" = {
              publicKey = ''
                # tangled
                ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2UShEm/FFPmYZUizaPnIqOJuynoCQpcLhl5PPHd02n
              '';
            };
          };
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
        programs = {
          ssh = {
            enable = true;
            enableDefaultConfig = false;

            includes = [
              "config.d/*"
            ];
            settings = {
              "github.com" = {
                HostName = "github.com";
                User = "git";
                IdentityFile = "~/.ssh/id_ed25519";
              };

              "tangled.org" = {
                HostName = "tangled.org";
                User = "git";
                IdentityFile = "~/.ssh/id_ed25519";
                AddressFamily = "inet";
              };

              "codeberg.org" = {
                HostName = "codeberg.org";
                User = "git";
                IdentityFile = "~/.ssh/id_ed25519";
              };

              "*" = {
                ForwardAgent = false;
                AddKeysToAgent = "no";
                Compression = false;
                ServerAliveInterval = 0;
                ServerAliveCountMax = 3;
                HashKnownHosts = false;
                UserKnownHostsFile = "~/.ssh/known_hosts";
                ControlMaster = "no";
                ControlPath = "~/.ssh/master-%r@%n:%p";
                ControlPersist = "no";
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

            defaultCacheTtl = 86400;
            maxCacheTtl = 86400;

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
