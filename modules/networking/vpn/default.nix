{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      programs.throne = {
        enable = true;

        tunMode.enable = true;
      };
    };
  };
}
