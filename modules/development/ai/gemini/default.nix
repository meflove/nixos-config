{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      config,
      lib,
      inputs,
      ...
    }: let
      gemini-wrapped = pkgs.symlinkJoin {
        name = "gemini-cli-wrapped";
        paths = [pkgs.gemini-cli];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/gemini \
            --run 'export GEMINI_API_KEY=$(cat ${config.hm.sops.secrets."ai/gemini_api_key".path})' \
            --run 'export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.hm.sops.secrets. "github/github_pat".path})' \
            --run 'export CONTEXT7_API_KEY=$(cat ${config.hm.sops.secrets."mcp/context7_api_key".path})' \
            --run 'export HUGGINGFACE_API_KEY=$(cat ${config.hm.sops.secrets."mcp/huggingface_api_key".path})' \
        '';
      };

      # Remove 'type' key from MCP server configuration for compatibility
      removeTypeFromServers = servers:
        servers
        |> lib.mapAttrs (_: server: lib.removeAttrs server ["type"]);
    in {
      hm = {
        sops = {
          secrets = lib.flattenSecrets {
            ai = {
              gemini_api_key = {};
            };
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
              preferredEditor = lib.getExe inputs.angeldust-nixcats.packages.${lib.hostPlatform}.default;

              checkpointing = {
                enabled = false;
              };
            };
          };
        };

        home = {
          packages = with pkgs; [
            geminicommit
            nodejs
          ];
        };
      };
    };
  };
}
