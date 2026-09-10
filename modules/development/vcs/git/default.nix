{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      pkgs,
      ...
    }: {
      hm = {
        home.packages = lib.attrValues {
          inherit
            (pkgs)
            diffnav # Diff viewer for git
            delta # diff viewer
            lazygit # Git TUI
            git-filter-repo
            gh
            ;
        };

        programs = {
          git = {
            enable = true;
            lfs = {
              enable = true;
            };

            includes = [
              {
                condition = ''hasconfig:remote.*.url:git@github.com:**/**'';
                contentSuffix = "github.git";
                contents = {
                  user = {
                    name = "meflove";
                    email = "meflov3r@icloud.com";
                    signingkey = "54B1AA165EA2E864";
                  };
                };
              }
              {
                condition = ''hasconfig:remote.*.url:git@tangled.org:**/**'';
                contentSuffix = "tangled.git";
                contents = {
                  gpg.format = "ssh";
                  user.signingkey = "/home/${lib.userName}/.ssh/id_ed25519.pub";
                };
              }
            ];

            settings = {
              user = {
                name = "angeldust";
                email = "meflov3r@icloud.com";
                signingkey = "54B1AA165EA2E864";
              };

              commit = {
                gpgsign = true;
              };
              tag = {
                gpgsign = true;
              };

              core = {
                editor = lib.getExe pkgs.editor;
                whitespace = "error";
                preloadindex = true;
                excludesfile = builtins.path {
                  path = pkgs.writeText "gitignore" ''
                    **/.omc
                    .cache
                    **/.claude/settings.local.json
                  '';
                };
              };

              diff = {
                renames = "copies";
                interHunkContext = 10;
              };

              pager.diff = "diffnav";

              pull = {
                default = "current";
                rebase = true;
              };

              push = {
                autoSetupRemote = true;
                default = "current";
              };

              rebase = {
                autoStash = true;
                missingCommitsCheck = "warn";
              };

              submodule = {
                fetchJobs = 16;
              };

              log = {
                abbrevCommit = true;
              };

              status = {
                branch = true;
                short = true;
                showStash = true;
                showUntrackedFiles = "all";
              };
            };
          };
        };
      };
    };
  };
}
