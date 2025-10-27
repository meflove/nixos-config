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
      lib.mkEnableOption "enable network configuration with NetworkManager and iwd"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [r8125];
      kernelModules = ["r8125"];
      blacklistedKernelModules = ["r8169"];
    };

    networking = {
      wireless.iwd = {
        settings = {
          General = {
            EnableNetworkConfiguration = true;
          };
          Setting = {
            AutoConnect = true;
          };
          Network = {
            EnableIPv6 = true;
          };
          Scan = {
            DisablePeriodicScan = false;
          };
        };
      };

      networkmanager = {
        enable = true;
        dhcp = "dhcpcd";
        dns = "systemd-resolved";
        wifi.backend = "iwd";
      };

      useDHCP = false;
      dhcpcd.enable = true;

      nameservers = ["192.168.1.1"];

      interfaces = {
        "enp3s0".wakeOnLan.enable = true;
        "wlan0".wakeOnLan.enable = true;
      };
    };

    systemd.services.NetworkManager-wait-online.enable = false;

    services.resolved = {
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
}
