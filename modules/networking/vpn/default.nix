{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      programs.throne = {
        enable = true;

        tunMode.enable = true;
      };
      environment.sessionVariables = {
        no_proxy = "127.0.0.1";
      };
    };
  };
}
