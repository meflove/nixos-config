{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      services.nohang = {
        enable = true;

        configPath = ./nohang-desktop.conf;
      };
    };
  };
}
