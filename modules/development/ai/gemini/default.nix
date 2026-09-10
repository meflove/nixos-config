{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      ...
    }: let
      gemini-wrapped = pkgs.symlinkJoin {
        name = "gemini-cli-wrapped";
        paths = [pkgs.llm-agents.gemini-cli];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/gemini \
            --run 'export GEMINI_API_KEY=$(cat ${config.nix-secrets.secrets."ai/gemini_api_key".path})' \
            --run 'export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.nix-secrets.secrets."github/github_pat".path})' \
            --run 'export CONTEXT7_API_KEY=$(cat ${config.nix-secrets.secrets."mcp/context7_api_key".path})' \
            --run 'export HUGGINGFACE_API_KEY=$(cat ${config.nix-secrets.secrets."mcp/huggingface_api_key".path})' \
        '';
      };

      # Remove 'type' key from MCP server configuration for compatibility
      removeTypeFromServers = servers:
        servers
        |> lib.mapAttrs (_: server: lib.removeAttrs server ["type"]);
    in {
      nix-secrets = {
        secrets = lib.flattenSecrets {
          ai = {
            gemini_api_key = {
              owner = lib.userName;
            };
          };
        };
      };

      hm = {
        sops = {
          secrets = lib.flattenSecrets {
            ai = {
              gemini_api_key = {};
            };
          };
        };

        home = {
          packages = lib.attrValues {
            inherit
              (pkgs)
              geminicommit
              nodejs
              ;
          };
        };

        programs.gemini-cli = {
          enable = true;
          package = gemini-wrapped;

          context = {
            GEMINI = builtins.readFile ./GEMINI.md;
          };

          settings = {
            mcpServers = removeTypeFromServers config.hm.programs.mcp.servers;

            context.fileName = ["GEMINI.md"];

            security = {
              auth = {
                selectedType = "gemini-api-key";
              };
            };

            tools = {
              exclude = ["ShellTool(rm -rf)"];
            };

            general = {
              preferredEditor = lib.getExe pkgs.editor;

              checkpointing = {
                enabled = false;
              };
            };
          };
        };
      };
    };
  };
}
