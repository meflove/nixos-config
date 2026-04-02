inputs @ {self, ...}: let
  extendedLib = import ./generator.nix {
    inherit self inputs;
  };

  inherit (extendedLib) nxosLib;
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
      (inputs.import-tree [../shells])
      (inputs.import-tree [../modules/flake])

      inputs.devenv.flakeModule
      inputs.disko.flakeModule
      inputs.flake-parts.flakeModules.bundlers
      inputs.home-manager.flakeModules.default
      inputs.pkgs-by-name-for-flake-parts.flakeModule
    ];

    flake = {config, ...}: {
      _module.args = {
        inherit extendedLib inputs;
        partsConfig = config;
      };

      # INFO:
      # nixosConfigurations,
      # diskoConfigurations are in ../hosts
      #
      # homeConfigurations,
    };

    perSystem = _: {
      _module.args = {inherit extendedLib inputs;};
    };
  }
