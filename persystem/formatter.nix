{
  perSystem = _: {
    treefmt = {
      programs = {
        # nix
        deadnix.enable = true;
        alejandra.enable = true;
        statix = {
          enable = true;
        };

        # md
        prettier = {
          enable = true;
          includes = ["*.md"];
          settings = {
            editorconfig = true;
          };
        };
      };
    };
  };
}
