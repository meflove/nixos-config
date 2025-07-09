{ config, pkgs, inputs, ... }:
{
  # Загрузчик: systemd-boot для UEFI систем
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  services.qemuGuest.enable = true; # Включает QEMU Guest Agent [8, 9]
  services.spice-vdagentd.enable = true; # Включает Spice VDAgent для копирования/вставки [9]

  # Включение экспериментальных функций Nix (для flakes)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Установка системной временной зоны
  time.timeZone = "Europe/Moscow";

  # Языковые настройки
  i1n.defaultLocale = "ru_RU.UTF-8";

  # Включение XWayland для совместимости со старыми приложениями
  programs.xwayland.enable = true;

  # Включение fish на системном уровне
  programs.fish.enable = true;

  # Настройка пользователя
  users.users.angeldust = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Для sudo и сети
    initialPassword = "2852";
  };

  # Дополнительные системные пакеты
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  # Импорт общих модулей NixOS, применимых к ВМ
  imports = [
    { services.qemuGuest.enable = true; }
    { services.spice-vdagentd.enable = true; }
    # Профиль QEMU Guest для оптимизации [10]
    inputs.nixpkgs.nixosModules.qemu-guest
    inputs.self.modules.nixos.disko-vm
    pkgs.nixosModules.qemu-guest
  ];

  # Установите имя хоста
  networking.hostName = "vm";

  system.stateVersion = "25.05"; # Или актуальная версия NixOS
}
