{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.development.ssh-and-gpg;
in {
  options.home.${namespace}.development.ssh-and-gpg = {
    enable =
      lib.mkEnableOption ''
        enable SSH and GPG configuration
      ''
      // {default = true;};
  };

  config = mkIf cfg.enable {
    programs = {
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

    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
      };
      ssh-agent = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
