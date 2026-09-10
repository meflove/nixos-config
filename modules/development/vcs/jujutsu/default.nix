{
  flake-file.inputs = {
    jujutsu.url = "github:jj-vcs/jj";
  };
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      pkgs,
      # inputs,
      ...
    }: {
      nix-secrets = {
        templates.allowed_signers = {
          content = "meflov3r@icloud.com ${config.nix-secrets.secrets."ssh-gpg/users/angeldust/ssh_pub"}";
          owner = lib.userName;
        };
      };

      hm = {
        home.packages = lib.attrValues {
          inherit
            (pkgs)
            diffnav # Diff viewer for git
            delta # diff viewer
            ;
        };
        programs = {
          jjui.enable = true;
          delta = {
            enable = true;
          };
          jujutsu = {
            enable = true;
            # package = inputs.jujutsu.packages.${lib.hostPlatform}.default;

            settings = {
              inherit (config.hm.programs.git.settings) user;

              signing = {
                key = config.hm.programs.git.settings.user.signingkey;
                backend = "gpg";
                behavior = "drop";
              };

              ui = {
                editor = lib.getExe pkgs.editor;
                show-cryptographic-signatures = true;
              };

              git = {
                fetch = "origin";
                push = "origin";
                write-change-id-header = true;
                sign-on-push = true;
                private-commits = "description(glob:'wip:*')";
              };

              remotes.origin.auto-track-bookmarks = "main";

              "--scope" = [
                {
                  "--when" = {
                    commands = ["diff" "show"];
                  };
                  ui = {
                    pager = "diffnav";
                    diff-formatter = ":git";
                  };
                }
                {
                  "--when" = {
                    environments = ["GIT_HOST=github"];
                  };
                  user = {
                    name = "meflove";
                    email = "meflov3r@icloud.com";
                  };
                }

                {
                  "--when" = {
                    environments = ["GIT_HOST=tangled"];
                  };
                  user = {
                    name = "angeldust.tngl.sh";
                  };
                  signing = {
                    key = "/home/${lib.userName}/.ssh/id_ed25519.pub";
                    backend = "ssh";
                    backends.ssh.allowed-signers = config.nix-secrets.templates.allowed_signers.path;
                  };
                }
              ];

              aliases = {
                init = ["git" "init" "--colocate"];
                g = ["git"];
                cma = ["commit" "-m"];
                clone = ["git" "clone"];
                fetch = ["git" "fetch"];
                push = ["git" "push"];
                logall = ["log" "-r" "all()"];
              };
            };
          };
        };
      };
    };
  };
}
