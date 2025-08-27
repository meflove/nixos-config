{
  description = "Моя модульная конфигурация NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-flatpak.url = "github:gmodena/nix-flatpak/";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    otter-launcher = {
      url = "github:kuokuo123/otter-launcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # Lanzaboote для Secure Boot и UKI.
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Дополнительные инпуты могут быть добавлены по мере необходимости,
    # например, для sops-nix (управление секретами), impermanence (персистентность).
  };

  outputs =
    {
      self,
      nixpkgs,
      chaotic,
      nix-gaming,
      nix-flatpak,
      home-manager,
      disko,
      rust-overlay,
      hyprland,
      hyprpanel,
      hyprland-plugins,
      otter-launcher,
      nixos-hardware,
      lanzaboote,
      zen-browser,
      freesmlauncher,
      ...
    }@inputs:
    {

      diskoConfigurations.vmDisk = import ./hosts/vm/vm-disk.nix;
      diskoConfigurations.pcDisk = import ./hosts/nixos-pc/nixos-pc-disk.nix;

      nixosConfigurations = {
        nixos-pc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos-pc/default.nix
            nixos-hardware.nixosModules.common-cpu-intel-cpu-only
            chaotic.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };

        vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/vm/default.nix ];
        };
      };

      homeConfigurations = {
        "angeldust" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            {
              home.username = "angeldust";
              home.homeDirectory = "/home/angeldust";
            }
            ./users/common/default.nix
          ];
        };

        "angeldust-vm" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            {
              home.username = "angeldust";
              home.homeDirectory = "/home/angeldust";
            }
            ./users/common/default.nix
          ];
        };
      };
    };
}
