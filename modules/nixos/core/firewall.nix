{
  lib,
  namespace,
  config,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.firewall;
in {
  options.${namespace}.nixos.core.firewall = {
    enable = lib.mkEnableOption "Enable firewall" // {default = true;};
  };

  config = mkIf cfg.enable {
    networking = {
      nftables = {
        enable = true;

        firewall = {
          enable = true;
          snippets.nnf-common.enable = true;

          zones = {
            uplink = {
              interfaces = [
                "enp3s0"
                "wlan0"
              ];
            };

            local = {
              parent = "uplink";
              ipv4Addresses = ["192.168.1.0/24"];
            };

            # for ethernet connections only
            private = {
              interfaces = [
                "enp3s0"
              ];
            };
          };

          rules = {
            private-postgresql = {
              from = "all";
              to = ["private"];
              allowedTCPPorts = [47950];
            };

            private-ssh = {
              from = "all";
              to = ["private"];
              allowedTCPPorts = [22];
            };

            private-outgoing = {
              from = ["private"];
              to = ["uplink"];
              verdict = "accept";
            };

            ban = {
              from = ["banned"];
              to = "all";
              ruleType = "ban";
              extraLines = [
                "counter drop"
              ];
            };
          };
        };
      };
    };
  };
}
