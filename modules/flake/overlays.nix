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
      master = import inputs.nixpkgs-master branch-config;

      mefPkgs = {
        soundcloud-desktop = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.soundcloud-desktop;
        yot = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.yot;
        iloader = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.iloader;
      };
      unazikxPkgs = inputs.unazikx-nix-packages.legacyPackages.${pkgs.stdenv.hostPlatform.system};

      nixos-cli = inputs.nixos-cli.packages.${pkgs.stdenv.hostPlatform.system}.nixos-cli.override {nix = _old.lix;};
      nix-update =
        inputs.nix-update.packages.${pkgs.stdenv.hostPlatform.system}.nix-update.overrideAttrs
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

      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      nix-gaming = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system};
      firefox-addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};

      ayugram-desktop = inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.ayugram-desktop;

      freesmlauncher = inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher.override {
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
    };
  };
}
