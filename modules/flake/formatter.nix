{
  perSystem = {inputs', ...}: {
    treefmt = {
      programs = {
        # nix
        deadnix.enable = true;
        alejandra.enable = true;
        statix = {
          enable = true;
          package = inputs'.statix.packages.statix;
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
