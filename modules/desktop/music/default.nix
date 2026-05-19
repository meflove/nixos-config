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
            (pkgs.angeldust-pkgs)
            soundcloud-desktop
            ;
        };
      };
    };
  };
}
