{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      nixpkgs.overlays = [
        (_self: super: {
          wpa_supplicant = super.wpa_supplicant.overrideAttrs (oldAttrs: {
            extraConfig =
              oldAttrs.extraConfig
              + ''
                CONFIG_WEP=y
              '';
          });
        })
      ];
      sops = let
        restartUnits = config.networking.wireless.interfaces |> lib.map (iface: "wpa_supplicant-${iface}");
      in {
        secrets = lib.flattenSecrets {
          wifi =
            lib.genAttrs [
              "Keenetic_home"
              "iphone_hotspot"
            ]
            (_: {inherit restartUnits;});
        };

        templates."wireless.conf" = {
          owner = "wpa_supplicant";
          content = ''
            psk_home=${config.sops.placeholder."wifi/Keenetic_home"}
            psk_iphone_hotspot=${config.sops.placeholder."wifi/iphone_hotspot"}
          '';
        };
      };

      users.users = {
        ${lib.userName} = {
          extraGroups = [
            "wheel"
          ];
        };
      };

      environment.systemPackages = lib.attrValues {
        inherit
          (pkgs)
          lsof
          ;
      };

      boot = {
        extraModulePackages = lib.attrValues {
          inherit
            (config.boot.kernelPackages)
            r8125
            ;
        };
        kernelModules = ["r8125"];
        blacklistedKernelModules = ["r8169"];
      };

      networking = {
        useDHCP = false;

        hosts = {
          "nixos-pc.localdomain" = ["nixos-pc"];
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
              ssid = "kto_kto_rkn";
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

              networkConfig = {
                DHCP = "yes";
                MulticastDNS = "yes";
              };

              linkConfig.RequiredForOnline = "carrier";

              # address = ["192.168.1.100/24"];
            };
            "10-wlan" = {
              matchConfig.PermanentMACAddress = "2c:33:58:12:68:03";

              # Lower priority route (higher = lower priority)
              dhcpV4Config.RouteMetric = 600;

              networkConfig = {
                DHCP = "yes";
                IgnoreCarrierLoss = "3s";
                MulticastDNS = "yes";
              };

              linkConfig.RequiredForOnline = "no";

              # address = ["192.168.1.101/24"];
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
