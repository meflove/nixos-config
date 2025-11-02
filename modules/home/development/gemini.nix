{
  pkgs,
  secrets,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.development.gemini;
in {
  options.${namespace}.home.development.gemini = {
    enable =
      lib.mkEnableOption "enable AI development environment with Gemini and Gemini-CLI"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    programs.gemini-cli = {
      enable = true;

      settings = {
        context.fileName = ["SMART.md" "GEMINI.md"];

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
            command = "${pkgs.nodejs}/bin/npx";
            args = [
              "-y"
              "@upstash/context7-mcp"
              "--api-key"
              secrets.context7.context7_api_key
            ];
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
              GITHUB_PERSONAL_ACCESS_TOKEN = secrets.github.github_pat;
            };
          };

          nixos = {
            command = "nix";
            args = [
              "run"
              "github:utensils/mcp-nixos"
            ];
          };
        };
      };
    };

    home = {
      sessionVariables = {
        GEMINI_API_KEY = secrets.gemini.gemini_api_key;
      };

      packages = with pkgs; [
        geminicommit
      ];
    };
  };
}
