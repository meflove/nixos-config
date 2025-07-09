{ config, pkgs, inputs, ... }:
{
  # Загрузчик: systemd-boot для UEFI систем
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  # Включение экспериментальных функций Nix (для flakes)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Установка системной временной зоны
  time.timeZone = "Asia/Krasnoyarsk";

  # Языковые настройки
  i18n.defaultLocale = "en_US.UTF-8";

  # Включение XWayland для совместимости со старыми приложениями
  programs.xwayland.enable = true;

  # Включение fish на системном уровне
  programs.fish.enable = true;

  # Настройка пользователя
  users.users.angeldust = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # Добавление в группы для sudo, сети, virt-manager [9, 11]
    initialPassword = ",jv;bybobt"; # Установите начальный пароль или используйте initialHashedPassword [5]
  };

  # Разрешение несвободного ПО, необходимого для драйверов NVIDIA [12]
  nixpkgs.config.allowUnfree = true;

  # Дополнительные системные пакеты
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  # Импорт общих модулей NixOS
  imports = [
    # Аппаратная конфигурация (генерируется nixos-generate-config)
    ./hardware-configuration.nix
    # Модули из директории modules/nixos
    inputs.self.modules.nixos.hyprland
    inputs.self.modules.nixos.nvidia
    inputs.self.modules.nixos.bluetooth
    inputs.self.modules.nixos.wifi
    inputs.self.modules.nixos.disko
    inputs.self.modules.nixos.secureboot
  ];

  # Установите имя хоста
  networking.hostName = "nixos-pc";

  system.stateVersion = "25.05"; # Или актуальная версия NixOS
}
