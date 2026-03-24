{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      lib,
      ...
    }: {
      hm = {
        home.packages = with pkgs; [
          inputs.ayugram-desktop.packages.${lib.hostPlatform}.ayugram-desktop
          session-desktop
        ];
      };
    };
  };
}
