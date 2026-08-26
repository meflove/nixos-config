{inputs, ...}: {
  flake = _: {
    overlays.default = _old: pkgs: let
      inherit (pkgs.stdenv.hostPlatform) system;

      branch-config = {
        inherit system;

        config = {
          inherit
            (_old.config)
            allowBroken
            allowInsecure
            allowUnfree
            ;
        };
      };
    in {
      # pkgSets
      master = import inputs.nixpkgs-master branch-config;
      unazikx-pkgs = inputs.unazikx-nix-packages.legacyPackages.${system};
      jonhermansen-nur-pkgs = inputs.jonhermansen-nur-packages.legacyPackages.${system};
      llm-agents = inputs.llm-agents.packages.${system};
      nix-gaming = inputs.nix-gaming.packages.${system};
      firefox-addons = inputs.firefox-addons.packages.${system};

      # pkgs
      ayugram-desktop = inputs.ayugram-desktop.packages.${system}.ayugram-desktop;
      freesmlauncher = inputs.freesmlauncher.packages.${system}.freesmlauncher.override {
        gamemodeSupport = true;
        controllerSupport = true;
        textToSpeechSupport = false;
      };
      iloader = inputs.iloader.packages.${system}.iloader;
      iris = inputs.iris.packages.${system}.iris;
      # devenv = inputs.devenv.packages.${system}.devenv;  # use prev.devenv to avoid lix-module override issue

      # fixes
      ananicy-cpp = inputs.nixpkgs-ananicy-cpp.legacyPackages.${system}.ananicy-cpp;
      nix = _old.lix;
      nixos-cli = inputs.nixos-cli.packages.${system}.nixos-cli.override {nix = _old.lix;};
      nix-update =
        inputs.nix-update.packages.${system}.nix-update.overrideAttrs
        (_finalAttrs: _previousAttrs: {
          nativBuildInputs = pkgs.lib.attrValues {
            inherit
              (_old)
              lix
              nix-prefetch-git
              ;
          };
          makeWrapperArgs = [
            "--prefix PATH"
            ":"
            (
              pkgs.lib.makeBinPath
              (
                pkgs.lib.attrValues {
                  inherit
                    (_old)
                    lix
                    nixpkgs-review
                    nix-prefetch-git
                    ;
                }
              )
            )
          ];
        });
      fastfetch = pkgs.fastfetch.override {
        zfsSupport = true;
      };
      # niri-flake pins libdisplay-info 0.2.0 via a stale `assert`, but niri
      # upstream requires 0.3 (Cargo.toml: `libdisplay-info = "0.3.0"`) and
      # nixpkgs removed `libdisplay-info_0_2` on 2026-08-04. The niri overlay
      # rebuilds against the system nixpkgs and hits that throw; shadow it here
      # with the flake's own derivation, swapping libdisplay-info for the 0.3.
      niri-unstable =
        inputs.niri.packages.${system}.niri-unstable.overrideAttrs
        (_: previousAttrs: {
          buildInputs =
            map
            (input:
              if pkgs.lib.getName input == "libdisplay-info"
              then pkgs.libdisplay-info_0_3
              else input)
            (previousAttrs.buildInputs or []);
        });
    };
  };
}
