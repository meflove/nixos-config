{
  pkgs,
  secrets,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.development.ai;

  geminiPrompt = builtins.readFile (pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/Maharshi-Pandya/4aeccbe1dbaa7f89c182bd65d2764203/raw/contemplative-llms.txt";
    sha256 = "sha256-QCWMW1Wxo9hffjvCd8lkEbTCHXQDkDUf1Wlo7ILbreo=";
  });
in {
  options.${namespace}.home.development.ai = {
    enable =
      lib.mkEnableOption "enable AI development environment with Gemini and Gemini-CLI"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    programs.gemini-cli = {
      enable = true;

      context = {
        SMART = geminiPrompt;
      };

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
            command = "npx";
            args = [
              "-y"
              "@upstash/context7-mcp"
            ];
          };

          github = {
            command = "podman";
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
