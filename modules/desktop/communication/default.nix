{
  extendedLib,
  self,
  ...
}: {
  flake-file.inputs = {
    ayugram-desktop = {
      url = "github:ndfined-crp/ayugram-desktop";
      inputs = extendedLib.mkNativeInputs [] self.inputs.ayugram-desktop.inputs;
    };
  };
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
            # session-desktop
            ayugram-desktop
            ;
        };
      };
    };
  };
}
