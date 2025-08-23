{ pkgs, ... }:
let
  secret = import ../../secrets/github.nix;
in
{
  programs.gemini-cli = {
    enable = true;
    settings = {
      excludeTools = [ "ShellTool(rm -rf)" ];

      preferredEditor = "nvim";
      checkpointing = {
        enabled = false;
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
          command = "uvx";
          args = [ "mcp-nixos" ];
        };
      };
    };
  };

  home.packages = with pkgs; [
    geminicommit
  ];
}
