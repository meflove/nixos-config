{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      services.flatpak = {
        enable = true;

        packages = [
          "org.vinegarhq.Sober"
        ];
      };
      xdg.portal.enable = true;
    };
  };
}
