{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      lib,
      config,
      ...
    }: let
      claude = pkgs.llm-agents.claude-code;
      omc = pkgs.llm-agents.oh-my-claudecode;
      # Wrapped claude-code package that injects secrets as environment variables
      claude-wrapped = pkgs.symlinkJoin {
        pname = "claude-code-wrapped";
        version = lib.getVersion claude;
        meta.mainProgram = "claude";
        paths = [claude];
        buildInputs = [pkgs.makeWrapper];
        # --run 'export ANTHROPIC_API_KEY=$(cat ${config.hm.sops.secrets."ai/openrouter_api_key".path})' \
        postBuild = ''
          wrapProgram $out/bin/claude \
            --run 'export ANTHROPIC_AUTH_TOKEN=$(cat ${config.hm.sops.secrets."ai/zai_api_key".path})' \
            --run 'export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.hm.sops.secrets."github/github_pat".path})' \
            --run 'export CONTEXT7_API_KEY=$(cat ${config.hm.sops.secrets."mcp/context7_api_key".path})' \
            --run 'export HUGGINGFACE_API_KEY=$(cat ${config.hm.sops.secrets."mcp/huggingface_api_key".path})' \
        '';
      };
    in {
      imports = [
        ./lsp.nix
      ];

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
          enableMcpIntegration = true;
          package = claude-wrapped;

          context =
            pkgs.concatText "claude-context" [
              ./CLAUDE.md
              "${omc}/lib/node_modules/oh-my-claude-sisyphus/docs/CLAUDE.md"
            ]
            |> builtins.readFile;

          skills = ./skills;

          plugins = {
            oh-my-claudecode = "${omc}/lib/node_modules/oh-my-claude-sisyphus";
          };

          settings = {
            alwaysThinkingEnabled = true;
            showThinkingSummaries = true;

            effortLevel = "high";

            tui = "fullscreen";

            attribution = {
              commit = "";
              pr = "";
              sessionUrl = false;
            };

            automode = {
              allow = [
                "$defaults"
                "Allow running vcs commands (jj, git) that are safe to run without rewriting the repo"
                "Allow running all find, grep, glob, log commands"
              ];
            };
            permissions = {
              allow = [
                "Task"
                "Bash(git log *)"
                "Bash(grep *)"
                "Bash(find *)"
                "Glob"
                "Grep"
                "LS"
                "Read"
                "WebFetch"
                "WebSearch"
              ];
            };

            autoCompactEnabled = true;
            autoCompactWindow = 1000000;

            env = {
              ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
              ANTHROPIC_DEFAULT_HAIKU_MODEL = "glm-5.3-flash";
              ANTHROPIC_DEFAULT_SONNET_MODEL = "glm-5.3";
              ANTHROPIC_DEFAULT_OPUS_MODEL = "glm-5.3";
              API_TIMEOUT_MS = 3000000;
              DISABLE_TELEMETRY = 1;
              CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
              CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY = 1;
              CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = 1;
              DISABLE_AUTOUPDATER = 1;
            };

            omcHud = {
              preset = "focused";
              elements = {
                omcLabel = false;
                model = false;
                contextBar = false;
                sessionHealth = false;
                showCallCounts = false;
                updateNotification = false;
                agentsFormat = "codes";
              };
            };

            statusLine = {
              type = "command";
              command = import ./statusline.nix {inherit pkgs omc;} |> lib.getExe;
            };
          };
        };

        home = {
          packages = [omc pkgs.nodejs_24 pkgs.ruby];
          file = {
            ".claude/agents" = {
              source = "${inputs.claude-agents.outPath}";
            };

            ".claude/hud/omc-hud.mjs".source = "${omc}/lib/node_modules/oh-my-claude-sisyphus/scripts/lib/hud-wrapper-template.txt";
            ".claude/hud/lib/config-dir.mjs".source = "${omc}/lib/node_modules/oh-my-claude-sisyphus/scripts/lib/config-dir.mjs";

            ".claude/.omc-config.json".text = builtins.toJSON {
              setupCompleted = "2026-09-09";
              setupVersion = lib.getVersion omc;
              team.ops = {
                maxAgents = 5;
                defaultAgentType = "claude";
                monitorIntervalMs = 30000;
                shutdownTimeoutMs = 15000;
              };
            };
          };
        };
      };
    };
  };
}
