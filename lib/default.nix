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
    nur.overlays.default
    atuin.overlays.default

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
    flake-file = {
      outputs = "args: import ./lib args";
      description = "My NixOS configuration managed with flake-parts";
      auto-follow.enable = true;

      inputs = {
        flake-parts = {
          url = "github:hercules-ci/flake-parts";
        };
        pkgs-by-name-for-flake-parts = {
          url = "github:drupol/pkgs-by-name-for-flake-parts";
        };
        pkgs-by-name.follows = "pkgs-by-name-for-flake-parts";
        import-tree = {
          url = "github:denful/import-tree";
        };
        flake-file = {
          url = "github:denful/flake-file";
        };
        disko = {
          url = "github:nix-community/disko";
        };
        home-manager = {
          url = "github:nix-community/home-manager";
        };
      };
    };

    systems = ["x86_64-linux"];

    # INFO:
    # outer-eval module arg: flake-file.inputs sites in persystem/ and
    # modules/ live in the top-level eval, not in the deferred `flake` one
    _module.args = {
      inherit extendedLib;
    };

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
      inputs.pedantix.flakeModules.default
      inputs.flake-file.flakeModules.default
      inputs.flake-file.flakeModules.auto-follow
      inputs.files.flakeModules.default
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
