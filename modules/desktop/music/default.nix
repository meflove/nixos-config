{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      ...
    }: {
      hm = {
        home.packages = with pkgs; [
          inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.soundcloud-desktop
          # master.cliamp
        ];
      };
    };
  };
}
