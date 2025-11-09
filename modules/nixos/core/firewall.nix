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
    enable =
      lib.mkEnableOption ''
        Enable advanced firewall configuration with nftables.

        Configures zone-based firewall with:
        - Separate zones for different network interfaces
        - Automatic SSH port opening for trusted networks
        - PostgreSQL access for local connections
        - Ban system for malicious IPs
        - Outgoing connections allowed from trusted zones
      ''
      // {default = true;};
  };

  config = mkIf cfg.enable {
    # Assertions to validate firewall configuration
    assertions = [
      {
        assertion = builtins.all (iface: config.networking.interfaces ? ${iface}) ["enp3s0" "wlan0"];
        message = "Firewall references network interfaces (enp3s0, wlan0) that are not defined in networking.interfaces.";
      }
    ];
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
