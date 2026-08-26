{
  perSystem = _: {
    treefmt = {
      settings = {
        global = {
          on-unmatched = "warn";
          excludes = [
            "secrets/*"
            ".sops.yaml"
            ".gitignore"
            ".envrc"
          ];
        };
      };
      programs = {
        # nix
        alejandra = {
          enable = true;
          priority = 1;
          includes = [
            "*.nix"
          ];
        };

        statix = {
          enable = true;
          priority = 2;
          includes = [
            "*.nix"
          ];
        };

        deadnix = {
          enable = true;
          no-underscore = true;
          priority = 3;
          includes = [
            "*.nix"
          ];
        };

        # md
        prettier = {
          enable = true;
          includes = [
            "*.md"
          ];
        };

        # json
        jsonfmt = {
          enable = true;
          includes = [
            "*.json"
          ];
        };

        # kdl
        kdlfmt = {
          enable = true;
          includes = [
            "*.kdl"
          ];
        };

        # py
        ruff-format = {
          enable = true;
          includes = [
            "*.py"
          ];
        };

        # toml
        taplo = {
          enable = true;
          includes = [
            "*.toml"
          ];
        };

        # yaml
        yamlfmt = {
          enable = true;
          includes = [
            "*.yaml"
            "*.yml"
          ];
        };
      };
    };
  };
}
