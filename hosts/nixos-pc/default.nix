{ pkgs, inputs, ... }:
let
  secret = import ../../secrets/pass.nix;
in
{
  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];
    system-features = [
      "nixos-test"
      "benchmark"
      "big-parallel"
      "kvm"
    ];
    auto-optimise-store = true;
    download-buffer-size = 2097152000;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
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
    initialPassword = secret.pass;
    shell = pkgs.fish;
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  # Дополнительные системные пакеты
  environment.systemPackages = with pkgs; [
    # --- CLI Tools ---
    # Core
    coreutils
    curl
    dig
    file
    killall
    pcre
    rsync
    tree
    unzip
    wget
    zip

    # Replacements
    bat # Better cat
    eza # Better ls
    fd # Better find
    ripgrep # Better grep
    sd # Better sed
    zoxide # Better cd
    ggh # Better SSH
    btop # Better top

    # Other
    chafa
    fzf # Fuzzy finder
    grc
    jq
    tlrc # Simplified man pages

    # --- Development ---
    # Compilers & Build Tools
    gnumake

    # Languages & Runtimes
    go
    nil
    nodejs_24
    zig

    # Git
    git
    lazygit # Git TUI

    # Libs
    openssl
    python313Packages.gpustat

    # --- Nix Ecosystem ---
    home-manager
    nix-search-tv
    television
    transcrypt

    # --- Graphics & Display ---
    # Vulkan
    vulkan-extension-layer
    vulkan-headers
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers

    # Wayland & GUI
    base16-schemes
    gtk3
    gtk4
    pavucontrol
    swww
    wl-clipboard
    nekoray

    # --- Audio ---
    easyeffects

    # --- Fun ---
    krabby
  ];

  imports = [
    # Модуль Disko для декларативной разметки диска [2]
    inputs.disko.nixosModules.disko # Импортируем основной модуль Disko
    inputs.self.diskoConfigurations.pcDisk # Импортируем нашу конфигурацию диска из flake
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    ../../modules/nixos/common.nix
    ../../modules/nixos/autologin.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/network.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/kernel.nix
    ../../modules/nixos/lang.nix
    ../../modules/nixos/rust/rustup.nix
    ../../modules/nixos/ccache.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/git.nix
    ../../modules/nixos/secureboot.nix
    ../../modules/nixos/secureboot.nix
    ../../modules/nixos/podman.nix
    ../../modules/nixos/virt-manager.nix
    ../../modules/nixos/ai.nix
    ../../modules/nixos/flatpak.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/iphone.nix
    ../../modules/nixos/torrent.nix
    ../../modules/nixos/optimisations.nix

    # Custom packages
    # ../../pkgs/custom_pkg.nix
  ];

  # Установите имя хоста
  networking.hostName = "nixos-pc";

  system.stateVersion = "25.05"; # Или акуальная версия NixOS
}
