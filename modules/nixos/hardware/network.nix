{ config, ... }:
{

  boot.extraModulePackages = with config.boot.kernelPackages; [ r8125 ];
  boot.kernelModules = [ "r8125" ];
  boot.blacklistedKernelModules = [ "r8169" ];

  networking.wireless.iwd = {
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

  networking = {
    useDHCP = false;
    dhcpcd.enable = true;

    nameservers = [ "192.168.1.1" ];

    networkmanager = {
      enable = true;
      dhcp = "dhcpcd";
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };

    interfaces = {
      "enp3s0".wakeOnLan.enable = true;
      "wlan0".wakeOnLan.enable = true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    dnsovertls = "false";
  };
}
