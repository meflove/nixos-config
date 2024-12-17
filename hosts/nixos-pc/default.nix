{ config, pkgs, inputs, ... }:
{
  # Загрузчик: systemd-boot для UEFI систем
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  # Включение экспериментальных функций Nix (для flakes)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Установка системной временной зоны
  time.timeZone = "Asia/Barnaul";

  # Языковые настройки
  i18n.defaultLocale = "en_US.UTF-8";

  # Включение XWayland для совместимости со старыми приложениями
  programs.xwayland.enable = true;

  # Включение fish на системном уровне
  programs.fish.enable = true;

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # SSH
  services.openssh = {
    enable = true;
    # settings.passwordAuthentication = false; # Recommended for security
  };

  zramSwap = {
    enable = true;
    priority = 100;
    swapDevices = 2;
    memoryPercent = 100;
  };

  # Настройка пользователя
  users.users.angeldust = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Добавление в группы для sudo, сети, virt-manager [9, 11]
    initialPassword = ",jv;bybobt"; # Установите начальный пароль или используйте initialHashedPassword [5]
    shell = pkgs.fish;
  };

  # Разрешение несвободного ПО, необходимого для драйверов NVIDIA [12]
  nixpkgs.config.allowUnfree = true;

  # Дополнительные системные пакеты
  environment.systemPackages = with pkgs; [
    # Basic CLIs
    eza # Better ls
    zoxide # Better cd
    bat # Better cat
    fd # Better find
    ripgrep # Better grep
    fzf # Fuzzy finder
    wget
    curl
    killall
    zip
    unzip
    jq
    rsync
    coreutils
    tree
    gcc
    clang
    zig
    grc
    bibata-cursors
    pcre
    file
    git

    # Nix workflow
    direnv
    home-manager

    # Git tools
    lazygit # Git TUI

    # System tools
    btop # Better top
    tldr # Simplified man pages

    # Development containers
    docker
  ];

  # Импорт общих модулей NixOS
  imports = [
    # Модуль Disko для декларативной разметки диска [2]
    inputs.disko.nixosModules.disko # Импортируем основной модуль Disko
    inputs.self.diskoConfigurations.pcDisk # Импортируем нашу конфигурацию диска из flake
  ];

  # Установите имя хоста
  networking.hostName = "nixos-pc";

  system.stateVersion = "25.05"; # Или актуальная версия NixOS
}
