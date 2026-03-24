{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      inputs,
      ...
    }: {
      hm = {
        home.packages = with pkgs; [
          diffnav # Diff viewer for git
          delta # diff viewer
          lazygit # Git TUI
          git-filter-repo
          gh
        ];

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
              };

              core = {
                editor = lib.getExe inputs.angeldust-nixCats.packages.${lib.hostPlatform}.default;
                whitespace = "error";
                preloadindex = true;
              };

              init = {
                defaultBranch = "dev";
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
