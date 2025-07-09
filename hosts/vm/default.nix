{ config, pkgs, inputs, ... }:
{
  myConfig.disk.targetDevice = "/dev/vda";

  # Загрузчик: systemd-boot для UEFI систем
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  # Добавляем необходимые драйверы для виртуальной машины в initrd
  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_mmio" "virtio_blk" ];

  services.qemuGuest.enable = true; # Включает QEMU Guest Agent [8, 9]
  services.spice-vdagentd.enable = true; # Включает Spice VDAgent для копирования/вставки [9]

  # Включение экспериментальных функций Nix (для flakes)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Установка системной временной зоны
  time.timeZone = "Europe/Moscow";

  # Языковые настройки
  i18n.defaultLocale = "en_US.UTF-8";

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
    # inputs.nixpkgs.nixosModules.qemu-guest
    # pkgs.nixosModules.qemu-guest

    # Модуль Disko для декларативной разметки диска [2]
    inputs.disko.nixosModules.disko # Импортируем основной модуль Disko
    inputs.self.modules.nixos.disko # Импортируем наш кастомный disko.nix, который определяет разметку

    inputs.self.modules.nixos.hyprland
  ];

  # Установите имя хоста
  networking.hostName = "vm";

  system.stateVersion = "25.05"; # Или актуальная версия NixOS
}
