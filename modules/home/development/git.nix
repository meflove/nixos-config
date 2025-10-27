{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.development.git;
in {
  options.${namespace}.home.development.git = {
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

      ssh = {
        enable = true;

        enableDefaultConfig = false;

        matchBlocks = {
          "github.com" = {
            user = "angeldust";
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
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    # Настройка SSH

    home.file = {
      ".ssh/id_ed25519".source = ../../../secrets/ssh/id_ed25519;
      ".ssh/id_ed25519.pub".source = ../../../secrets/ssh/id_ed25519.pub;
    };
  };
}
