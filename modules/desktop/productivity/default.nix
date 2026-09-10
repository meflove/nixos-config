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
            obsidian
            libreoffice
            papers # PDF viewer
            # for libreoffice
            corefonts
            vista-fonts
            ;
        };
      };
    };
  };
}
