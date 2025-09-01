{ config, ... }:
{

  boot.extraModulePackages = with config.boot.kernelPackages; [ r8125 ];
  boot.kernelModules = [ "r8125" ];
  boot.blacklistedKernelModules = [ "r8169" ];

  networking = {
    useDHCP = false;
    dhcpcd.enable = true;

    nameservers = [ "192.168.1.1" ];
  };

  networking.wireless.iwd = {
    enable = true;
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

  networking.networkmanager = {
    enable = true;
    dhcp = "dhcpcd";
    dns = "systemd-resolved";
    wifi.backend = "iwd";
  };

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
