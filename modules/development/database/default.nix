{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      pkgs,
      ...
    }: {
      hm = {
        home.packages = lib.attrValues {
          inherit
            (pkgs)
            dbeaver-bin
            sqlite
            postgresql
            ;
        };
      };
    };
  };
}
