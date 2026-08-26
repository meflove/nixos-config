{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
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

            settings = {
              user = {
                name = "meflove";
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
