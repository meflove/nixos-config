inputs @ {self, ...}: let
  extendedLib = import ./generator.nix {
    inherit
      self
      inputs
      overlays
      ;
  };

  overlays = with inputs; [
    niri.overlays.niri
    hyprland.overlays.default
    nix-cachyos-kernel.overlays.default
    angeldust-nix-packages.overlays.default
    # zellij.overlays.default

    (import "${statix}/overlay.nix")
    self.overlays.default
  ];

  inherit
    (extendedLib)
    nxosLib
    ;
in
  inputs.flake-parts.lib.mkFlake
  {
    inherit inputs;
  }
  {
    systems = ["x86_64-linux"];

    imports = [
      # INFO:
      # will import only default.nix configurations
      # semi-dendritic
      (inputs.import-tree.filter (nxosLib.hasSuffix "default.nix") [
        ../modules
        ../hosts
      ])
      (inputs.import-tree [../persystem])

      inputs.devenv.flakeModule
      inputs.disko.flakeModule
      inputs.flake-parts.flakeModules.bundlers
      inputs.home-manager.flakeModules.default
      inputs.pkgs-by-name-for-flake-parts.flakeModule
      inputs.treefmt-nix.flakeModule
    ];

    flake = {config, ...}: {
      _module.args = {
        inherit
          extendedLib
          self
          inputs
          ;

        _config = config;
      };

      # INFO:
      # nixosConfigurations,
      # diskoConfigurations are in ../machines
      #
      # homeConfigurations,
    };

    perSystem = {system, ...}: {
      _module.args = {
        inherit
          extendedLib
          inputs
          ;

        pkgs = import inputs.nixpkgs {
          inherit
            system
            overlays
            ;
        };
      };
    };
  }
