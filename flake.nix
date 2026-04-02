{
  description = "My NixOS configuration managed with snowfall";

  inputs = {
    # Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    import-tree.url = "github:vic/import-tree";
    chaotic = {
      url = "github:lonerOrz/nyx-loner";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/";
    nix-gaming.url = "github:fufexan/nix-gaming";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    ## devenv deps
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    statix = {
      url = "github:molybdenumsoftware/statix";
    };
    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## bun2nix
    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System & Boot
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        rust-overlay.follows = "rust-overlay";
      };
    };
    ## Fix build for lanzaboote
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop Environment
    ## Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## Niri
    niri = {
      url = "github:sodiboo/niri-flake";
    };

    # Home Manager & User Apps
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## Utils
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    nix-cursors = {
      url = "github:LilleAila/nix-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## GUI
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
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
      url = "https://github.com/ndfined-crp/ayugram-desktop";
      type = "git";
      submodules = true;
    };
    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord/5f38b1630b5af54ea7bad2a2308298fe10648a36";
    };
    jonhermansen-nur-packages = {
      url = "github:jonhermansen/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## TUI
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    angeldust-nixCats = {
      url = "github:meflove/angeldust-nixCats";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
    };
    otter-launcher = {
      url = "github:kuokuo123/otter-launcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fsel = {
      url = "github:Mjoyufull/fsel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
    };
    nh = {
      url = "github:nix-community/nh";
    };
    nix-index = {
      url = "github:nix-community/nix-index";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Services & Networking
    nnf = {
      url = "github:thelegy/nixos-nftables-firewall";
    };
    zapret-presets = {
      url = "github:kotudemo/zapret-presets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = args: import ./lib args;
}
