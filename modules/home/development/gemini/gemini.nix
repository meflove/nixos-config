{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.development.gemini;

  gemini-wrapped = pkgs.symlinkJoin {
    name = "gemini-cli-wrapped";
    paths = [pkgs.gemini-cli];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/gemini \
        --run 'export GEMINI_API_KEY=$(cat ${config.sops.secrets."gemini/gemini_api_key".path})' \
        --run 'export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.sops.secrets."github/github_pat".path})' \
        --run 'export CONTEXT7_API_KEY=$(cat ${config.sops.secrets."context7/context7_api_key".path})' \
        --run 'export HUGGINGFACE_API_KEY=$(cat ${config.sops.secrets."huggingface/huggingface_api_key".path})' \
    '';
  };

  # Remove 'type' key from MCP server configuration for compatibility
  removeTypeFromServers = servers:
    lib.mapAttrs (_: server: lib.removeAttrs server ["type"]) servers;
in {
  options.home.${namespace}.development.gemini = {
    enable =
      lib.mkEnableOption "enable AI development environment with Gemini and Gemini-CLI"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    sops = {
      secrets = lib.angl.flattenSecrets {
        gemini = {
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
        mcpServers = removeTypeFromServers config.programs.mcp.servers;

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
          preferredEditor = "nvim";

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
}
