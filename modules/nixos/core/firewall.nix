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
    networking = {
      # Enable NAT for Waydroid container
      nat = {
        enable = true;
        internalInterfaces = ["waydroid0"];
        externalInterface = "enp3s0";
      };

      nftables = {
        enable = true;

        firewall = {
          enable = true;
          snippets.nnf-common.enable = true;

          zones = {
            uplink = {
              interfaces = [
                "enp3s0"
                "wlp4s0"
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

            # Waydroid Android container zone
            waydroid = {
              interfaces = ["waydroid0"];
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

            private-fastapi-dev = {
              from = "all";
              to = ["private"];
              allowedTCPPorts = [8000];
            };

            # DNS for Waydroid container
            waydroid-dns = {
              from = ["waydroid"];
              to = ["fw"];
              allowedUDPPorts = [53 67];
            };

            # Allow Waydroid to access internet (forwarding to uplink)
            waydroid-forward = {
              from = ["waydroid"];
              to = ["uplink"];
              verdict = "accept";
            };

            # Allow traffic from Waydroid to host (for ADB, etc)
            waydroid-to-host = {
              from = ["waydroid"];
              to = ["fw"];
              verdict = "accept";
            };

            private-wake-on-lan = {
              from = "all";
              to = ["private"];
              allowedUDPPorts = [9];
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
