{
  inputs,
  pkgs,
  lib,
  namespace,
  config,
  ...
}: {
  imports = [
    # Disko config
    ./nixos-pc-disk.nix
  ];

  sops = {
    secrets = lib.angl.flattenSecrets {
      github = {
        github_pat_devenv = {};
      };
      pass = {};
    };

    templates = {
      "nix-access-tokens.nix".content = ''
        access-tokens = "github.com=${config.sops.placeholder."github/github_pat_devenv"}";
      '';
    };
  };

  nix = {
    package = pkgs.lix;

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    channel.enable = false;

    settings = {
      use-xdg-base-directories = true;

      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];

      substituters = lib.mkForce [
        "https://nixos-cache-proxy.cofob.dev"
        "https://nixos-cache-proxy.sweetdogs.ru"
        "https://nix-gaming.cachix.org"
        "https://chaotic-nyx.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
        "https://yazi.cachix.org"
        "https://devenv.cachix.org"
        "https://nvim-treesitter-main.cachix.org"
        "https://niri.cachix.org"
        "https://watersucks.cachix.org"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "nvim-treesitter-main.cachix.org-1:cbwE6blfW5+BkXXyeAXoVSu1gliqPLHo2m98E4hWfZQ="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];

      auto-allocate-uids = true;
      use-cgroups = true;

      auto-optimise-store = true;

      # With Lix, i cant use this option
      # download-buffer-size = 2097152000;
    };

    extraOptions = ''
      !include ${config.sops.templates."nix-access-tokens.nix".path}
    '';
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
          kernelPackage = pkgs.linuxPackages_cachyos.cachyOverride {
            mArch = "GENERIC_V3";
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
        dankMaterialShell.enable = true;
        flatpak = {
          enable = true;
          flatpakPackages = [
            "org.vinegarhq.Sober"
          ];
        };

        gaming.enable = true;

        videoTools = {
          enable = true;
          obs.enable = false;
        };
        torrent.enable = true;
      };

      development = {
        ollama.enable = false;
        podman.enable = true;
        virtManager.enable = true;
      };

      hardware = {
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
    hashedPasswordFile = config.sops.secrets.pass.path;
    shell = pkgs.fish;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit namespace;};
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;

    packages = with pkgs; [nerd-fonts.jetbrains-mono];
  };

  environment.systemPackages = with pkgs; [
    # === Core System Utilities ===
    # Essential CLI tools for system administration
    coreutils
    curl
    dig
    file
    killall
    rsync
    tree
    wget

    # File management and compression
    unzip
    zip
    rar
    unrar
    _7zz-rar
    gparted

    # Development tools and libraries
    gnumake
    openssl
    pcre

    # Network diagnostics and security
    nmap

    # === Nix Ecosystem ===
    # Nix package management tools
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    snowfallorg.flake

    # === Graphics & Display System ===
    # GUI framework and clipboard utilities
    gtk3
    gtk4
    base16-schemes
    pwvucontrol
    wl-clipboard
  ];

  networking.hostName = "nixos-pc";

  system.stateVersion = "25.05";
}
