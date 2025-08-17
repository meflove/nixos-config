{ pkgs, inputs, ... }: {
  # Включение экспериментальных функций Nix (для flakes)
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    auto-optimise-store = true;
    download-buffer-size = 2097152000;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Включение XWayland для совместимости со старыми приложениями
  programs.xwayland.enable = true;

  # Включение fish на системном уровне
  programs.fish.enable = true;

  programs.hyprland = {
    enable = true;
    # set the flake package
    package =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # SSH
  services.openssh = {
    enable = true;
    # settings.passwordAuthentication = false; # Recommended for security
  };

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [{
        command = "/run/current-system/sw/bin/nixos-rebuild";
        options = [ "NOPASSWD" ];
      }];
      groups = [ "wheel" ];
    }];
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
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "gamemode"
    ]; # Добавление в группы для sudo, сети, virt-manager [9, 11]
    initialPassword =
      ",jv;bybobt"; # Установите начальный пароль или используйте initialHashedPassword [5]
    shell = pkgs.fish;
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  };

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
    grc
    pcre
    file
    git
    gnumake
    uv
    sd
    krabby
    chafa

    # Libs
    python313Packages.gpustat

    # Nix workflow
    direnv
    home-manager
    nix-search-tv
    television

    # Git tools
    lazygit # Git TUI

    # Languages
    zig
    go
    nodejs_24
    nil
    python3Full

    # System tools
    btop # Better top
    tldr # Simplified man pages

    # Development containers
    docker

    # Vulkan
    vulkan-tools

    # Wayland
    wl-clipboard
    swww
    base16-schemes
    pavucontrol

    # Audio
    easyeffects
  ];

  imports = [
    # Модуль Disko для декларативной разметки диска [2]
    inputs.disko.nixosModules.disko # Импортируем основной модуль Disko
    inputs.self.diskoConfigurations.pcDisk # Импортируем нашу конфигурацию диска из flake
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    "${inputs.self}/modules/nixos/autologin.nix"
    "${inputs.self}/modules/nixos/nvidia.nix"
    "${inputs.self}/modules/nixos/pipewire.nix"
    "${inputs.self}/modules/nixos/network.nix"
    "${inputs.self}/modules/nixos/bluetooth.nix"
    "${inputs.self}/modules/nixos/kernel.nix"
    "${inputs.self}/modules/nixos/lang.nix"
    "${inputs.self}/modules/nixos/rust/rustup.nix"
    "${inputs.self}/modules/nixos/ccache.nix"
    "${inputs.self}/modules/nixos/gaming.nix"
    "${inputs.self}/modules/nixos/git.nix"
    "${inputs.self}/modules/nixos/secureboot.nix"
    "${inputs.self}/modules/nixos/secureboot.nix"
    "${inputs.self}/modules/nixos/podman.nix"
    "${inputs.self}/modules/nixos/virt-manager.nix"

  ];

  # Установите имя хоста
  networking.hostName = "nixos-pc";

  system.stateVersion = "25.05"; # Или акуальная версия NixOS
}
