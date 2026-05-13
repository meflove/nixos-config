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
      mefPkgs = {
        soundcloud-desktop = inputs.self.packages.${system}.soundcloud-desktop;
        yot = inputs.self.packages.${system}.yot;
        iloader = inputs.self.packages.${system}.iloader;
      };
      unazikxPkgs = inputs.unazikx-nix-packages.legacyPackages.${system};
      llm-agents = inputs.llm-agents.packages.${system};
      nix-gaming = inputs.nix-gaming.packages.${system};
      firefox-addons = inputs.firefox-addons.packages.${system};

      # pkgs
      ayugram-desktop = inputs.ayugram-desktop.packages.${system}.ayugram-desktop;
      freesmlauncher = inputs.freesmlauncher.packages.${system}.freesmlauncher.override {
        gamemodeSupport = true;
        controllerSupport = true;
        textToSpeechSupport = false;

        jdks = _old.lib.attrValues {
          inherit
            (_old)
            # its all LTS
            # https://adoptium.net/temurin/releases
            temurin-jre-bin-25
            temurin-jre-bin-21
            temurin-jre-bin-17
            temurin-jre-bin-8
            ;
        };
      };

      # fixes
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
      fastfetch = pkgs.fastfetch.override {zfsSupport = true;};
    };
  };
}
