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
          editor = prev.symlinkJoin {
            name = "nvimWrap-wrapped";
            meta.mainProgram = "nvim";
            paths = [inputs.angeldust-nvimWrap.packages.${lib.hostPlatform}.default];
            buildInputs = [prev.makeWrapper];
            postBuild =
              # bash
              ''
                wrapProgram $out/bin/nvim \
                  --run 'export GITHUB_COPILOT_TOKEN=$(cat ${config.hm.sops.secrets."ai/copilot_oauth".path})' \
                  --run 'export OPENROUTER_API_KEY=$(cat ${config.hm.sops.secrets."ai/openrouter_api_key".path})' \
                  --run 'export ANTHROPIC_API_KEY=$(cat ${config.hm.sops.secrets."ai/zai_api_key".path})' \
              '';
          };
        })
      ];

      hm = {
        sops = {
          secrets = lib.flattenSecrets {
            ai = {
              copilot_oauth = {};
              openrouter_api_key = {};
              zai_api_key = {};
            };
          };
        };
        home = {
          packages = [
            pkgs.editor
          ];

          sessionVariables = {
            EDITOR = lib.getExe pkgs.editor;
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
