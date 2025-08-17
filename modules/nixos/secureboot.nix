{ pkgs, lib, ... }: {

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";

  };

  # Для использования Lanzaboote с systemd-boot
  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    efi = {
      efiSysMountPoint = "/efi";
      canTouchEfiVariables =
        true; # Необходимо для записи в переменные UEFI [27]
    };
  };

  # Добавление Lanzaboote в системные пакеты
  environment.systemPackages = with pkgs; [ sbctl ];

}
