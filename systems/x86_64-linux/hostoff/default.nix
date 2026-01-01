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
    ./hostoff-disk.nix
  ];

  virtualisation.qemu.guest.enable = true;
  services.qemuGuest.enable = true;

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

  angl = {
    nixos = {
      boot = {
        kernelOptimisations = {
          enable = true;
          cpuGovernor = "performance";
          kernelPackage = pkgs.linuxPackages_latest;
        };

        secureBoot = {
          disableWarning = false;
          enable = true;
        };
      };
      core = {
        autologin = {
          enable = false;
          user = "angeldust";
        };
        common = {enable = false;};
        firewall = {enable = false;};
        optimisations = {enable = false;};
        security = {enable = false;};
        ssh = {enable = true;};
        vpn = {enable = false;};
        zapret = {enable = false;};
      };
      desktop = {
        dankMaterialShell = {enable = false;};
        flatpak = {
          enable = false;
          flatpakPackages = ["org.vinegarhq.Sober"];
        };
        gaming = {enable = false;};
        torrent = {enable = false;};
        videoTools = {
          enable = false;
          gpuScreenRecorder = {enable = false;};
          obs = {enable = false;};
        };
      };
      development = {
        ollama = {
          enable = false;
          openWebui = false;
        };
        podman = {enable = false;};
        virtManager = {enable = false;};
      };
      hardware = {
        bluetooth = {enable = false;};
        iphone = {enable = false;};
        network = {enable = false;};
        nvidia = {enable = false;};
        sound = {enable = false;};
      };
    };
  };

  snowfallorg.users.angeldust.home.enable = false;

  users.users.angeldust = {
    extraGroups = [
      "input"
      "networkmanager"
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
  ];

  networking.hostName = "vps-6332";

  system.stateVersion = "26.05";
}
