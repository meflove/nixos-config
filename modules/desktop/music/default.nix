{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {lib, ...}: {
      hm = {
        home.packages =
          lib.attrValues {
          };
      };
    };
  };
}
