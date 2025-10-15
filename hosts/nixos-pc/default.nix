{
  inputs,
  pkgs,
  lib,
  ...
}: let
  secret = import ../../secrets/pass.nix;
  multranslate = pkgs.callPackage ../../pkgs/multranslate/default.nix {};
  slit = pkgs.callPackage ../../pkgs/slit {};
in {
  nix = {
    settings = {
      substituters = lib.mkForce [
        "https://nixos-cache-proxy.cofob.dev"
        "https://nix-gaming.cachix.org"
        "https://chaotic-nyx.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      auto-optimise-store = true;

      # With Lix, i cant use this option
      # download-buffer-size = 2097152000;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
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

    packages = with pkgs; [nerd-fonts.jetbrains-mono];
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
    nmap

    # Libs
    gnumake
    openssl

    # --- Nix Ecosystem ---
    home-manager
    snowfallorg.flake

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
    pwvucontrol
    wl-clipboard
  ];

  imports = [
    inputs.disko.nixosModules.disko
    inputs.self.diskoConfigurations.pcDisk
    inputs.lix-module.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nnf.nixosModules.default
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.chaotic.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.solaar.nixosModules.default

    # Boot
    ../../modules/nixos/boot/kernel.nix
    ../../modules/nixos/boot/secureboot.nix

    # Core
    ../../modules/nixos/core/autologin.nix
    ../../modules/nixos/core/common.nix
    ../../modules/nixos/core/lang.nix
    ../../modules/nixos/core/optimisations.nix
    ../../modules/nixos/core/security.nix
    ../../modules/nixos/core/firewall.nix
    ../../modules/nixos/core/vpn.nix

    # Desktop
    ../../modules/nixos/desktop/screen_record.nix
    ../../modules/nixos/desktop/obs.nix

    # Development
    ../../modules/nixos/development/ai.nix
    ../../modules/nixos/development/ccache.nix
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

    # pkgs
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      cudaSupport = true;
      permittedInsecurePackages = [
        "mbedtls-2.28.10"
      ];
    };

    overlays = with inputs; [
      snowfall-flake.overlays."package/flake"
    ];
  };

  networking.hostName = "nixos-pc";

  system.stateVersion = "25.05";
}
