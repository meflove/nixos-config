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
    "${inputs.self}/modules/nixos/common.nix"
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
    "${inputs.self}/modules/nixos/ai.nix"
    "${inputs.self}/modules/nixos/flatpak.nix"
    "${inputs.self}/modules/nixos/security.nix"
    "${inputs.self}/modules/nixos/iphone.nix"
    "${inputs.self}/modules/nixos/torrent.nix"
    "${inputs.self}/modules/nixos/optimisations.nix"
  ];

  # Установите имя хоста
  networking.hostName = "nixos-pc";

  system.stateVersion = "25.05"; # Или акуальная версия NixOS
}
