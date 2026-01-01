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
        --run 'export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.sops.secrets."github/github_pat".path})' \
        --run 'export CONTEXT7_API_KEY=$(cat ${config.sops.secrets."context7/context7_api_key".path})' \
        --run 'export GEMINI_API_KEY=$(cat ${config.sops.secrets."gemini/gemini_api_key".path})'
    '';
  };
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

        mcpServers = {
          context7 = {
            type = "http";
            url = "https://mcp.context7.com/mcp";
            headers = {
              CONTEXT7_API_KEY = "\${CONTEXT7_API_KEY}";
            };
          };

          github = {
            command = "${lib.getExe pkgs.podman}";
            args = [
              "run"
              "-i"
              "--rm"
              "-e"
              "GITHUB_PERSONAL_ACCESS_TOKEN"
              "ghcr.io/github/github-mcp-server"
            ];
            env = {
              GITHUB_PERSONAL_ACCESS_TOKEN = "\${GITHUB_PERSONAL_ACCESS_TOKEN}";
            };
          };

          nixos = {
            command = "${lib.getExe pkgs.podman}";
            args = [
              "run"
              "--rm"
              "-i"
              "ghcr.io/utensils/mcp-nixos"
            ];
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
