{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      inputs,
      lib,
      ...
    }: let
      nixCats = inputs.angeldust-nixCats.packages.${lib.hostPlatform}.default;
    in {
      hm = {
        home = {
          packages = [
            nixCats
          ];

          sessionVariables = {
            EDITOR = lib.getExe nixCats;
            NVIM_APPNAME = "nvim-og";
          };
        };

        editorconfig = {
          enable = true;

          settings = {
            "*" = {
              charset = "utf-8";
              end_of_line = "lf";
              trim_trailing_whitespace = true;
              insert_final_newline = true;
              max_line_width = 100;
              indent_style = "space";
              indent_size = 2;
            };

            "*.rs" = {
              indent_size = 4;
            };
          };
        };
      };
    };
  };
}
