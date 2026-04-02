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
    };
  };
}
