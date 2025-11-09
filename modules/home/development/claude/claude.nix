{
  pkgs,
  secrets,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.development.claude;
in {
  options.${namespace}.home.development.claude = {
    enable =
      lib.mkEnableOption "enable AI development environment with claude-code"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      memory.source = ./CLAUDE.md;

      commands = {
        commit = ./commands/COMMIT.md;
        code_review = ./commands/CODE_REVIEW.md;
        full_review = ./commands/FULL_REVIEW.md;
      };

      settings = {
        permissions = {
          allow = [
            "Task"
            "Bash(git log:*)"
            "Bash(grep:*)"
            "Bash(find:*)"
            "Glob"
            "Grep"
            "LS"
            "Read"
            "WebFetch"
            "WebSearch"
          ];
          deny = [
            "Bash(curl:*)"
            "Bash(rm -rf:*)"
          ];
        };

        env = {
          ANTHROPIC_DEFAULT_OPUS_MODEL = "GLM-4.6";
          ANTHROPIC_DEFAULT_SONNET_MODEL = "GLM-4.6";
          ANTHROPIC_DEFAULT_HAIKU_MODEL = "GLM-4.5-Air";
          ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
          ANTHROPIC_AUTH_TOKEN = secrets.claude.zai_api_key;
          DISABLE_TELEMETRY = 1;
        };

        statusLine = {
          type = "command";
          command = "~/.claude/statusline.py";
        };
      };

      mcpServers = {
        context7 = {
          type = "http";
          url = "https://mcp.context7.com/mcp";
          headers = {
            CONTEXT7_API_KEY = secrets.context7.context7_api_key;
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
            GITHUB_PERSONAL_ACCESS_TOKEN = secrets.github.github_pat;
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

    home.file.".claude/statusline.py" = {
      source = ./statusline.py;
      executable = true;
    };
  };
}
