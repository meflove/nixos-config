{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      networking = {
        firewall.checkReversePath = true;
        nftables = {
          enable = true;

          firewall = {
            enable = true;
            snippets.nnf-common.enable = true;

            zones = {
              uplink = {
                interfaces = [
                  "lan0"
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
                  "lan0"
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
                allowedTCPPorts = [2222];
              };

              private-fastapi-dev = {
                from = ["local"];
                to = ["fw"];
                allowedTCPPorts = [8000];
              };

              private-webserver-dev = {
                from = ["local"];
                to = ["fw"];
                allowedTCPPorts = [8080];
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
  };
}
