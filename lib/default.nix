inputs @ {self, ...}: let
  extendedLib = import ./generator.nix {
    inherit
      self
      inputs
      ;
  };

  inherit
    (extendedLib)
    nxosLib
    ;
in
  inputs.flake-parts.lib.mkFlake
  {
    inherit
      inputs
      ;
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

      inputs.devenv.flakeModule
      inputs.disko.flakeModule
      inputs.flake-parts.flakeModules.bundlers
      inputs.home-manager.flakeModules.default
    ];

    flake = {config, ...}: {
      _module.args = {
        inherit extendedLib inputs;
        partsConfig = config;
      };

      nixConfig = {
        allow-import-from-derivation = true;
        extra-experimental-features = [
          "pipe-operator" # Lix naming
          "pipe-operators"
        ];

        extra-substituters = [
          "https://nixos-cache-proxy.cofob.dev"
          "https://mirror.yandex.ru/nixos"
          "https://cache.nixos-cuda.org"
          "https://nix-gaming.cachix.org"
          "https://chaotic-nyx.cachix.org"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://cache.garnix.io"
          "https://yazi.cachix.org"
          "https://devenv.cachix.org"
          "https://nvim-treesitter-main.cachix.org"
          "https://niri.cachix.org"
          "https://watersucks.cachix.org"
          "https://claude-code.cachix.org"
        ];
        extra-trusted-public-keys = [
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "nvim-treesitter-main.cachix.org-1:cbwE6blfW5+BkXXyeAXoVSu1gliqPLHo2m98E4hWfZQ="
          "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
          "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
          "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
        ];
      };
      # INFO:
      # nixosConfigurations,
      # diskoConfigurations are in ../machines
      #
      # homeConfigurations,
    };

    perSystem = {pkgs, ...}: {
      _module.args = {inherit extendedLib inputs;};
      packages = {
        clipse = pkgs.callPackage ../packages/clipse {};
        hyprscope = pkgs.callPackage ../packages/hyprscope {};
        iloader = pkgs.callPackage ../packages/iloader {};
        soundcloud-desktop = pkgs.callPackage ../packages/soundcloud-desktop {};
        yot = pkgs.callPackage ../packages/yot {};
      };
    };

    debug = true;
  }
