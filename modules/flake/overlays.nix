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
      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    };
  };
}
