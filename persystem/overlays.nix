{
  extendedLib,
  inputs,
  self,
  ...
}: {
  flake-file.inputs = {
    # INFO:
    # url-style declaration — flake-edit (auto-follow) does not match
    # attrset-style (type/owner/repo/ref) inputs as follows targets
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    angeldust-nix-packages = {
      url = "git+https://tangled.org/did:plc:jv6arfakxixeyppnbxhf6blz";
      # INFO: keep the subtree on nix-packages' own pinned inputs; dev tooling
      # (flake-parts, pkgs-by-name, treefmt-nix, import-tree) is deduplicated
      inputs = extendedLib.mkNativeInputs [] self.inputs.angeldust-nix-packages.inputs;
    };
    jonhermansen-nur-packages.url = "github:jonhermansen/nur-packages";
    chaotic.url = "github:chaotic-cx/nyx";
    nur.url = "github:nix-community/NUR";
  };
  flake = _: {
    overlays.default = final: prev: let
      inherit (prev.stdenv.hostPlatform) system;

      branch-config = {
        inherit system;

        config = {
          inherit
            (final.config)
            allowBroken
            allowInsecure
            allowUnfree
            ;
        };
      };
    in {
      # pkgSets
      master = import inputs.nixpkgs-master branch-config;
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
      nix = final.lix;
      nixos-cli = inputs.nixos-cli.packages.${system}.nixos-cli.override {nix = final.lix;};
      nix-update =
        inputs.nix-update.packages.${system}.nix-update.overrideAttrs
        (_finalAttrs: _previousAttrs: {
          nativBuildInputs = prev.lib.attrValues {
            inherit
              (final)
              lix
              nix-prefetch-git
              ;
          };
          makeWrapperArgs = [
            "--prefix PATH"
            ":"
            (
              prev.lib.makeBinPath
              (
                prev.lib.attrValues {
                  inherit
                    (final)
                    lix
                    nixpkgs-review
                    nix-prefetch-git
                    ;
                }
              )
            )
          ];
        });
      fastfetch = prev.fastfetch.override {
        zfsSupport = true;
      };
    };
  };
}
