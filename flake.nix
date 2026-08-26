{
  description = "My NixOS configuration managed with flake-parts";

  inputs = {
    # Core
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    nixpkgs-master = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
    };
    nixpkgs-ananicy-cpp = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "148bab9c1c3c53136ecb44a6ea356a0ed5b39b06";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        lix.follows = "lix";
      };
    };
    nix-update = {
      type = "github";
      owner = "Mic92";
      repo = "nix-update";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    ncro = {
      type = "github";
      owner = "feel-co";
      repo = "ncro";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## flake-parts
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pkgs-by-name-for-flake-parts = {
      type = "github";
      owner = "drupol";
      repo = "pkgs-by-name-for-flake-parts";
    };
    import-tree = {
      type = "github";
      owner = "denful";
      repo = "import-tree";
    };
    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ### devenv deps
    devenv = {
      type = "github";
      owner = "cachix";
      repo = "devenv";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        rust-overlay.follows = "rust-overlay";
        flake-compat.follows = "flake-compat";
        ghostty.follows = "ghostty";
      };
    };
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    mk-shell-bin = {
      type = "github";
      owner = "rrbutani";
      repo = "nix-mk-shell-bin";
    };
    git-hooks = {
      type = "github";
      owner = "cachix";
      repo = "git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    statix = {
      type = "github";
      owner = "molybdenumsoftware";
      repo = "statix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
      };
    };
    nix2container = {
      type = "github";
      owner = "nlewo";
      repo = "nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      type = "github";
      owner = "NixOS";
      repo = "flake-compat";
    };
    ## other
    chaotic = {
      type = "github";
      owner = "chaotic-cx";
      repo = "nyx";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      type = "github";
      owner = "gmodena";
      repo = "nix-flatpak";
    };
    nix-gaming = {
      type = "github";
      owner = "fufexan";
      repo = "nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
      };
    };
    angeldust-nix-packages = {
      type = "github";
      owner = "meflove";
      repo = "nix-packages";
      inputs = {
        flake-parts.follows = "flake-parts";
        pkgs-by-name.follows = "pkgs-by-name-for-flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    nur = {
      type = "github";
      owner = "nix-community";
      repo = "NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    emmanuelrosa-nix = {
      type = "github";
      owner = "emmanuelrosa";
      repo = "erosanix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    # System & Boot
    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    ## Fix build for lanzaboote
    rust-overlay = {
      type = "github";
      owner = "oxalica";
      repo = "rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## secrets
    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## kernel
    nix-cachyos-kernel = {
      type = "github";
      owner = "xddxdd";
      repo = "nix-cachyos-kernel";
      inputs = {
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
      };
    };

    # Desktop Environment
    ## Hyprland
    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";
    };
    ## Niri
    niri = {
      type = "github";
      owner = "epireyn";
      repo = "niri-flake";
    };

    # Home Manager & User Apps
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## Utils
    stylix = {
      type = "github";
      owner = "nix-community";
      repo = "stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        nur.follows = "nur";
      };
    };
    nix-cursors = {
      type = "github";
      owner = "LilleAila";
      repo = "nix-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## GUI
    zen-browser = {
      type = "github";
      owner = "0xc000022070";
      repo = "zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ayugram-desktop = {
      type = "git";
      url = "https://github.com/ndfined-crp/ayugram-desktop";
      submodules = true;
    };
    freesmlauncher = {
      type = "github";
      owner = "FreesmTeam";
      repo = "FreesmLauncher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    nixcord = {
      type = "github";
      owner = "kaylorben";
      repo = "nixcord";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs"; # does not need cache hit
        nixpkgs-nixcord.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    system24-theme = {
      type = "github";
      owner = "refact0r";
      repo = "system24";
      flake = false;
    };
    iloader = {
      type = "github";
      owner = "nab138";
      repo = "iloader";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
        flake-compat.follows = "flake-compat";
      };
    };
    jonhermansen-nur-packages = {
      type = "github";
      owner = "jonhermansen";
      repo = "nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## TUI
    ghostty = {
      type = "github";
      owner = "ghostty-org";
      repo = "ghostty";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-compat.follows = "flake-compat";
      };
    };
    angeldust-nixCats = {
      type = "github";
      owner = "meflove";
      repo = "angeldust-nixCats";
    };
    angeldust-nvimWrap = {
      type = "github";
      owner = "meflove";
      repo = "angeldust-nvimWrap";
    };
    llm-agents = {
      type = "github";
      owner = "numtide";
      repo = "llm-agents.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    claude-agents = {
      type = "github";
      owner = "contains-studio";
      repo = "agents";
      flake = false;
    };
    otter-launcher = {
      type = "github";
      owner = "kuokuo123";
      repo = "otter-launcher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };
    fsel = {
      type = "github";
      owner = "Mjoyufull";
      repo = "fsel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      type = "github";
      owner = "sxyazi";
      repo = "yazi";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    zellij = {
      type = "github";
      owner = "a-kenji";
      repo = "zellij-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-compat.follows = "flake-compat";
      };
    };
    iris = {
      type = "github";
      owner = "versenilvis";
      repo = "iris";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    nh = {
      type = "github";
      owner = "nix-community";
      repo = "nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index = {
      type = "github";
      owner = "nix-community";
      repo = "nix-index";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    nix-index-database = {
      type = "github";
      owner = "nix-community";
      repo = "nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cli = {
      type = "github";
      owner = "nix-community";
      repo = "nixos-cli";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
      };
    };

    # Services & Networking
    nnf = {
      type = "github";
      owner = "thelegy";
      repo = "nixos-nftables-firewall";
    };
    proxy-suite-flake = {
      type = "github";
      owner = "fufsob";
      repo = "proxy-suite-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zapret.follows = "zapret-discord-youtube";
      };
    };
    zapret-discord-youtube = {
      type = "github";
      owner = "kartavkun";
      repo = "zapret-discord-youtube";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = args: import ./lib args;
}
