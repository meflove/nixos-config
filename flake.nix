{
  description = "Моя модульная конфигурация NixOS";

  inputs = {
    # Core
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    chaotic.url = "github:chaotic-cx/nyx/main";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/";
    nix-gaming.url = "github:fufexan/nix-gaming";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System & Boot
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop Environment
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager & User Apps
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## Utils
    nix-colors.url = "github:misterio77/nix-colors";
    nix-cursors = {
      url = "github:LilleAila/nix-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## GUI
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ayugram-desktop = {
      url = "https://github.com/ndfined-crp/ayugram-desktop/";
      type = "git";
      submodules = true;
    };
    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
    };
    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## TUI
    angeldust-nixCats = {
      url = "github:meflove/angeldust-nixCats";
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

    # Services & Networking
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };
    nnf = {
      url = "github:thelegy/nixos-nftables-firewall";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    secrets = import ./secrets/secrets.nix;
  in
    inputs.snowfall-lib.mkFlake {
      overlays = with inputs; [
        lix-module.overlays.default
        snowfall-flake.overlays.default
      ];

      inherit inputs;
      src = ./.;
      supportedSystems = ["x86_64-linux"];

      snowfall = {
        root = ./.;
        namespace = "angl";

        meta = {
          name = "nixos-config";
          title = "angeldust`s NixOS Configuration";
        };
      };

      channels-config = {
        # Allow unfree packages.
        allowUnfree = true;
      };

      systems.hosts = {
        nixos-pc = {
          specialArgs = {
            inherit secrets;
          };

          modules = with inputs; [
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            nnf.nixosModules.default
            nixos-hardware.nixosModules.common-cpu-intel-cpu-only
            chaotic.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            solaar.nixosModules.default
          ];
        };
      };

      homes.users = {
        "angeldust@nixos-pc" = {
          specialArgs = {
            inherit secrets;
          };

          modules = with inputs; [
            zen-browser.homeModules.default
            otter-launcher.homeModules.default
            hyprland.homeManagerModules.default
            nixcord.homeModules.nixcord
            nix-colors.homeManagerModules.default
            chaotic.homeManagerModules.default
          ];
        };
      };

      outputs-builder = channels: {
        # Outputs in the outputs builder are transformed to support each system. This
        # entry will be turned into multiple different outputs like `formatter.x86_64-linux.*`.
        formatter = channels.nixpkgs.alejandra;
      };
    };
}
