{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.development.git;
in {
  options.home.${namespace}.development.git = {
    enable =
      lib.mkEnableOption "enable git configuration and related tools"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
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

        settings = {
          user = {
            name = "meflove";
            email = "meflov3r@icloud.com";
          };

          core = {
            editor = "nixCats";
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
}
