{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      sops = let
        restartUnits = config.networking.wireless.interfaces |> lib.map (iface: "wpa_supplicant-${iface}");
      in {
        secrets = lib.flattenSecrets {
          wifi = {
            Keenetic_home = {
              inherit restartUnits;
            };
            iphone_hotspot = {
              inherit restartUnits;
            };
          };
        };

        templates."wireless.conf" = {
          content = ''
            psk_home=${config.sops.placeholder."wifi/Keenetic_home"}
            psk_iphone_hotspot=${config.sops.placeholder."wifi/iphone_hotspot"}
          '';
          owner = "wpa_supplicant";
        };
      };

      environment.systemPackages = with pkgs; [
        lsof
      ];

      boot = {
        extraModulePackages = with config.boot.kernelPackages; [r8125];
        kernelModules = ["r8125"];
        blacklistedKernelModules = ["r8169"];
      };

      networking = {
        useDHCP = false;

        hosts = {
          "130.255.77.28" = ["ntc.party"];
          "30.255.77.28" = ["ntc.party"];
          "144.31.113.60" = ["hostoff-pl"];
          "192.168.1.1" = ["router"];
        };

        wireless = {
          enable = true;
          userControlled = true;
          driver = "nl80211";
          secretsFile = config.sops.templates."wireless.conf".path;
          interfaces = ["wlan0"];

          networks = {
            Keenetic-60 = {
              pskRaw = "ext:psk_home";
              authProtocols = [
                # WPA2 and WPA3
                "WPA-PSK"
                "SAE"
                # 802.11r variants of the above
                "FT-PSK"
                "FT-SAE"
              ];
            };
            iPhone-16-pro = {
              # ssid = "найди меня если сможешь";
              pskRaw = "ext:psk_iphone_hotspot";
            };
          };
        };

        nameservers = ["192.168.1.1"];
      };

      systemd = {
        network = {
          enable = true;
          wait-online.enable = false;

          networks = {
            "10-lan" = {
              matchConfig.PermanentMACAddress = "04:7c:16:59:5c:65";

              # Higher priority route (lower = higher priority)
              dhcpV4Config.RouteMetric = 100;
              dhcpV6Config.RouteMetric = 100;

              networkConfig = {
                DHCP = "yes";
                MulticastDNS = "yes";
              };

              # Wait for routable state instead of just carrier
              linkConfig.RequiredForOnline = "routable";

              address = ["192.168.1.100/24"];
            };
            "10-wlan" = {
              matchConfig.PermanentMACAddress = "2c:33:58:12:68:03";

              # Lower priority route (higher = lower priority)
              dhcpV4Config.RouteMetric = 600;
              dhcpV6Config.RouteMetric = 600;

              linkConfig.RequiredForOnline = "no";

              networkConfig = {
                DHCP = "yes";
                IgnoreCarrierLoss = "3s";
                MulticastDNS = "yes";
              };
            };
          };
          links = {
            "10-lan" = {
              matchConfig.PermanentMACAddress = "04:7c:16:59:5c:65";
              linkConfig = {
                Name = "lan0";
                WakeOnLan = "magic";
              };
            };
            "10-wlan" = {
              matchConfig.PermanentMACAddress = "2c:33:58:12:68:03";
              linkConfig = {
                Name = "wlan0";
              };
            };
          };
        };
      };

      services = {
        resolved = {
          enable = true;
          settings = {
            Resolve = {
              Domains = ["~."];
              DNS = config.networking.nameservers;
              DNSOverTLS = false;
              DNSSEC = false;
              MulticastDNS = "yes";
              LLMNR = "no";
              FallbackDNS = [
                "1.1.1.1"
                "8.8.8.8"
                "9.9.9.9"
              ];
            };
          };
        };
      };
    };
  };
}
