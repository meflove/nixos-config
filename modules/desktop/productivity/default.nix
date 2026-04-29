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
            (pkgs)
            obsidian
            libreoffice
            # papers # PDF viewer
            ;
        };
      };
    };
  };
}
