{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      inputs,
      lib,
      pkgs,
      config,
      ...
    }: {
      nixpkgs.overlays = [
        (_final: prev: {
          nixCats = prev.symlinkJoin {
            name = "nixCats-wrapped";
            meta.mainProgram = "nixCats";
            paths = [inputs.angeldust-nixCats.packages.${lib.hostPlatform}.default];
            buildInputs = [prev.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/nixCats \
                --run 'export GITHUB_COPILOT_TOKEN=$(cat ${config.hm.sops.secrets."ai/copilot_oauth".path})'
            '';
          };
        })
      ];
      hm = {
        sops = {
          secrets = lib.flattenSecrets {
            ai = {
              copilot_oauth = {};
            };
          };
        };

        home = {
          packages = [
            pkgs.nixCats
          ];

          sessionVariables = {
            EDITOR = lib.getExe pkgs.nixCats;
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
