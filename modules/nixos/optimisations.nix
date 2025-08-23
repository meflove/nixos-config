{ pkgs, ... }:
{
  services.earlyoom = {
    enable = true;

    enableNotifications = true;
  };

  environment.systemPackages = with pkgs; [
    irqbalance
  ];
}
