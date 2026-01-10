{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.hardware.network;
in {
  options.${namespace}.nixos.hardware.network = {
    enable =
      lib.mkEnableOption "enable network configuration with systemd-networkd and wpa_supplicant"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    sops = {
      secrets = lib.angl.flattenSecrets {
        wifi = {
          Keenetic_home = {};
        };
      };

      templates."wireless.conf" = {
        content = ''
          psk_home=${config.sops.placeholder."wifi/Keenetic_home"}
        '';
        owner = "wpa_supplicant";
      };
    };
    systemd.services."wpa_supplicant-wlp4s0".after = ["sops-nix.service"];

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

        interfaces = ["wlp4s0"];

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
        };
      };

      nameservers = ["192.168.1.1"];

      networkmanager = {
        enable = false;
        dhcp = "dhcpcd";
        dns = "systemd-resolved";
        wifi.backend = "iwd";
      };
    };

    systemd = {
      network = {
        enable = true;
        wait-online.enable = false;

        networks = {
          "10-lan" = {
            matchConfig.Path = "pci-0000:03:00.0";
            networkConfig = {
              DHCP = "yes";
            };
            address = ["192.168.1.100/24"];
          };
          "10-wlan" = {
            matchConfig.Path = "pci-0000:04:00.0";
            linkConfig.RequiredForOnline = "no";
            networkConfig = {
              DHCP = "yes";
              IgnoreCarrierLoss = "3s";
            };
          };
        };
        links = {
          "10-lan" = {
            matchConfig.Path = "pci-0000:03:00.0";
            linkConfig = {
              Name = "enp3s0";
              WakeOnLan = "magic";
            };
          };
          "10-wlan" = {
            matchConfig.Path = "pci-0000:04:00.0";
            linkConfig = {
              Name = "wlp4s0";
              WakeOnLan = "magic";
            };
          };
        };
      };
    };

    services = {
      resolved = {
        enable = true;
        dnssec = "false";
        domains = ["~."];
        fallbackDns = [
          "1.1.1.1"
          "8.8.8.8"
          "9.9.9.9"
        ];
        dnsovertls = "false";
      };
    };
  };
}
