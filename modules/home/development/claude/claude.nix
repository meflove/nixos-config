{
  inputs,
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
    paths = [inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code-bun];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      # Create symlink claude -> claude-bun for programs.claude-code compatibility
      ln -s $out/bin/claude-bun $out/bin/claude

      wrapProgram $out/bin/claude \
        --run 'export ANTHROPIC_AUTH_TOKEN=$(cat ${config.sops.secrets."ai/zai_api_key".path})' \
        --run 'export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.sops.secrets."github/github_pat".path})' \
        --run 'export CONTEXT7_API_KEY=$(cat ${config.sops.secrets."mcp/context7_api_key".path})' \
        --run 'export HUGGINGFACE_API_KEY=$(cat ${config.sops.secrets."mcp/huggingface_api_key".path})' \
        --run 'export BRIGHTDATA_API_KEY=$(cat ${config.sops.secrets."mcp/brightdata_api_key".path})'
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
        ai = {
          zai_api_key = {};
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

      mcpServers = config.programs.mcp.servers;

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
