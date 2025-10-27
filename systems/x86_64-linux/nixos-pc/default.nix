{
  inputs,
  pkgs,
  lib,
  system,
  secrets,
  ...
}: {
  nix = {
    package = pkgs.lix;

    settings = {
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];

      substituters = lib.mkForce [
        "https://nixos-cache-proxy.cofob.dev"
        "https://nix-gaming.cachix.org"
        "https://chaotic-nyx.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
        "https://yazi.cachix.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      auto-optimise-store = true;

      access-tokens = "github.com=${secrets.github.github_pat_devenv}";

      # With Lix, i cant use this option
      # download-buffer-size = 2097152000;
    };
  };

  nixpkgs = {
    config = {
      cudaSupport = true;
    };
  };

  angl = {
    nixos = {
      boot = {
        kernelOptimisations = {
          enable = true;
          kernelPackage = pkgs.linuxPackages_cachyos-lto.cachyOverride {
            mArch = "GENERIC_V3";
            useLTO = "thin";
          };
        };

        secureBoot = {
          enable = true;
          disableWarning = true;
        };
      };

      core = {
        vpn.enable = true;
      };

      desktop = {
        flatpak = {
          enable = true;
          flatpakPackages = [
            "org.vinegarhq.Sober"
          ];
        };

        gaming = {
          enable = true;
          wine.package = inputs.nix-gaming.packages.${system}.wine-tkg;
        };

        obs.enable = true;
        screenRecord.enable = true;
        torrent.enable = true;
      };

      development = {
        ollama.enable = true;
        podman.enable = true;
        virtManager.enable = true;
      };

      harware = {
        iphone.enable = true;
      };
    };
  };

  snowfallorg.users.angeldust.home.enable = false;

  users.users.angeldust = {
    extraGroups = [
      "input"
      "networkmanager"
      "gamemode"
    ];
    initialPassword = secrets.pass;
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
    zip
    rar
    unrar
    _7zz-rar
    wget
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
    # Disko config
    ./nixos-pc-disk.nix
  ];

  networking.hostName = "nixos-pc";

  system.stateVersion = "25.05";
}
