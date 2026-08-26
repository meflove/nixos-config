{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      pkgs,
      ...
    }: let
      iris = pkgs.iris.overrideAttrs {
        vendorHash = "sha256-huyTWK6ef42KY2zmFIQuFoeR8B8XKHE7OVfFnfefeCU=";
      };
    in {
      hm = {
        home.packages = lib.attrValues {
          inherit
            iris
            ;
        };
      };
    };
  };
}
