{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.development.claude;

  claudeAgents = pkgs.fetchFromGitHub {
    owner = "contains-studio";
    repo = "agents";
    rev = "a5a480c324cac64b9c569bca0b2f297d517240cb";
    sha256 = "sha256-yZ7llkqGBAmGPc7wooxzk0X7qWkW/zTv5VWISIyCYz8=";
  };

  # Wrapped claude-code package that injects secrets as environment variables
  claude-wrapped = pkgs.symlinkJoin {
    name = "claude-code-wrapped";
    paths = [pkgs.claude-code];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --run 'export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.sops.secrets."github/github_pat".path})' \
        --run 'export CONTEXT7_API_KEY=$(cat ${config.sops.secrets."context7/context7_api_key".path})' \
        --run 'export ANTHROPIC_AUTH_TOKEN=$(cat ${config.sops.secrets."claude/zai_api_key".path})'
    '';
  };
in {
  options.home.${namespace}.development.claude = {
    enable =
      lib.mkEnableOption "enable AI development environment with claude-code"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    sops = {
      secrets = lib.angl.flattenSecrets {
        github = {
          github_pat = {};
        };
        claude = {
          zai_api_key = {};
        };
        context7 = {
          context7_api_key = {};
        };
      };
    };

    programs.claude-code = {
      enable = true;
      package = claude-wrapped;

      memory.source = ./CLAUDE.md;

      commands = {
        commit = ./commands/COMMIT.md;
        code_review = ./commands/CODE_REVIEW.md;
        full_review = ./commands/FULL_REVIEW.md;
      };

      settings = {
        alwaysThinkingEnabled = true;

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
          ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
          API_TIMEOUT_MS = 3000000;
          DISABLE_TELEMETRY = 1;
          DISABLE_AUTOUPDATER = 1;
          MAX_THINKING_TOKENS = 10000;
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

    home.file = {
      ".claude/statusline.py" = {
        source = ./statusline.py;
        executable = true;
      };
      ".claude/agents" = {
        source = "${claudeAgents}";
      };
    };
  };
}
