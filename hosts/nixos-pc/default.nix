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

    # With Lix, i cant use this option
    # download-buffer-size = 2097152000;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  services.cockpit = {
    enable = true;
  };

  users.users.angeldust = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
      "networkmanager"
      "gamemode"
    ];
    initialPassword = secret.pass;
    shell = pkgs.fish;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
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
    snowfallorg.flake
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
    inputs.lix-module.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote

    # Boot
    ../../modules/nixos/boot/kernel.nix
    ../../modules/nixos/boot/secureboot.nix

    # Core
    ../../modules/nixos/core/autologin.nix
    ../../modules/nixos/core/common.nix
    ../../modules/nixos/core/lang.nix
    ../../modules/nixos/core/optimisations.nix
    ../../modules/nixos/core/security.nix

    # Desktop
    ../../modules/nixos/desktop/screen_record.nix

    # Development
    ../../modules/nixos/development/ai.nix
    ../../modules/nixos/development/ccache.nix
    ../../modules/nixos/development/git.nix
    ../../modules/nixos/development/podman.nix
    ../../modules/nixos/development/rust/rustup.nix
    ../../modules/nixos/development/virt-manager.nix

    # Hardware
    ../../modules/nixos/hardware/bluetooth.nix
    ../../modules/nixos/hardware/iphone.nix
    ../../modules/nixos/hardware/network.nix
    ../../modules/nixos/hardware/nvidia.nix
    ../../modules/nixos/hardware/pipewire.nix

    # Services
    ../../modules/nixos/services/ssh.nix
    ../../modules/nixos/services/torrent.nix

    # Software
    ../../modules/nixos/software/flatpak.nix
    ../../modules/nixos/software/gaming.nix
  ];

  nixpkgs.overlays = with inputs; [
    snowfall-flake.overlays."package/flake"
  ];

  networking.hostName = "nixos-pc";

  system.stateVersion = "25.05";
}
