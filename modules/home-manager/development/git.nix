{pkgs, ...}: {
  home.packages = with pkgs; [
    diffnav
    git-filter-repo
    pre-commit
  ];

  programs.git = {
    enable = true;
    userName = "meflove";
    userEmail = "meflov3r@icloud.com";

    extraConfig = {
      core = {
        editor = "nvim";
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
}
