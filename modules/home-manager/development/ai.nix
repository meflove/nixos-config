{ pkgs, ... }:
let
  secret = import ../../../secrets/github.nix;
in
{
  programs.gemini-cli = {
    enable = true;
    settings = {
      security = {
        auth = {
          selectedType = "gemini-api-key";
        };
      };

      tools = {
        exclude = [ "ShellTool(rm -rf)" ];
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
            GITHUB_PERSONAL_ACCESS_TOKEN = secret.GITHUB_PAT;
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

  home.packages = with pkgs; [
    geminicommit
  ];
}
