{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      inputs,
      config,
      ...
    }: let
      claudeAgents = pkgs.fetchFromGitHub {
        owner = "contains-studio";
        repo = "agents";
        rev = "a5a480c324cac64b9c569bca0b2f297d517240cb";
        sha256 = "sha256-yZ7llkqGBAmGPc7wooxzk0X7qWkW/zTv5VWISIyCYz8=";
      };

      # Wrapped claude-code package that injects secrets as environment variables
      claude-wrapped = pkgs.symlinkJoin {
        name = "claude-code-wrapped";
        paths = [inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code-bun pkgs.python3];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          # Create symlink claude -> claude-bun for programs.claude-code compatibility
          ln -s $out/bin/claude-bun $out/bin/claude

          wrapProgram $out/bin/claude \
            --run 'export ANTHROPIC_AUTH_TOKEN=$(cat ${config.hm.sops.secrets."ai/zai_api_key".path})' \
            --run 'export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.hm.sops.secrets."github/github_pat".path})' \
            --run 'export CONTEXT7_API_KEY=$(cat ${config.hm.sops.secrets."mcp/context7_api_key".path})' \
            --run 'export HUGGINGFACE_API_KEY=$(cat ${config.hm.sops.secrets."mcp/huggingface_api_key".path})' \
        '';
      };
    in {
      hm = {
        sops = {
          secrets = lib.flattenSecrets {
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

          mcpServers = config.hm.programs.mcp.servers;

          settings = {
            alwaysThinkingEnabled = true;
            effortLevel = "high";

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
              CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
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
    };
  };
}
