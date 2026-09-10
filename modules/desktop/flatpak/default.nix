{
  flake-file.inputs = {
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      services.flatpak = {
        enable = true;
        update.auto.enable = true;

        packages = [
          "org.vinegarhq.Sober"
        ];
      };
      xdg.portal.enable = true;
    };
  };
}
