{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      ...
    }: {
      hm = {
        home.packages = lib.attrValues {
          inherit
            (pkgs.mefPkgs)
            soundcloud-desktop
            ;
          # inherit
          #   (pkgs)
          #   cliamp
          #   ;
        };
      };
    };
  };
}
