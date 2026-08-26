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
      # Wrapped claude-code package that injects secrets as environment variables
      claude-wrapped = pkgs.symlinkJoin {
        pname = "claude-code-wrapped";
        version = lib.getVersion claude;
        meta.mainProgram = "claude";
        paths = [claude pkgs.python3];
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

          context = ./CLAUDE.md;

          commands = {
            code_review = ./commands/CODE_REVIEW.md;
            full_review = ./commands/FULL_REVIEW.md;
          };
          skills = ./skills;

          lspServers = {
            nixd = {
              command = lib.getExe pkgs.nixd;
              extensionToLanguage = {
                ".nix" = "nix";
              };
            };
            pyright = {
              command = lib.getExe' pkgs.basedpyright "basedpyright-langserver";
              args = [
                "--stdio"
              ];
              extensionToLanguage = {
                ".py" = "python";
                ".pyi" = "python";
              };
            };
            rust-analyzer = {
              command = lib.getExe pkgs.rust-analyzer;
              extensionToLanguage = {
                ".rs" = "rust";
              };
            };
            typescript = {
              args = [
                "--stdio"
              ];
              command = lib.getExe pkgs.typescript-language-server;
              extensionToLanguage = {
                ".js" = "javascript";
                ".jsx" = "javascriptreact";
                ".ts" = "typescript";
                ".tsx" = "typescriptreact";
              };
            };
            bashls = {
              command = lib.getExe pkgs.bash-language-server;
              args = [
                "start"
              ];
              extensionToLanguage = {
                ".sh" = "shellscript";
                ".bash" = "shellscript";
                ".zsh" = "shellscript";
              };
            };
            clangd = {
              command = lib.getExe' pkgs.clang-tools "clangd";
              args = [
                "--background-index"
              ];
              extensionToLanguage = {
                ".c" = "c";
                ".h" = "c";
                ".cpp" = "cpp";
                ".cc" = "cpp";
                ".cxx" = "cpp";
                ".hpp" = "cpp";
                ".hxx" = "cpp";
                ".C" = "cpp";
                ".H" = "cpp";
              };
            };
            lua_ls = {
              command = lib.getExe pkgs.lua-language-server;
              extensionToLanguage = {
                ".lua" = "lua";
              };
            };
            marksman = {
              command = lib.getExe pkgs.marksman;
              args = [
                "server"
              ];
              extensionToLanguage = {
                ".md" = "markdown";
              };
            };
            jsonls = {
              command = lib.getExe' pkgs.vscode-json-languageserver "vscode-json-language-server";
              args = [
                "--stdio"
              ];
              extensionToLanguage = {
                ".json" = "json";
                ".jsonc" = "jsonc";
              };
            };
            yamlls = {
              command = lib.getExe pkgs.yaml-language-server;
              args = [
                "--stdio"
              ];
              extensionToLanguage = {
                ".yaml" = "yaml";
              };
            };
          };

          settings = {
            alwaysThinkingEnabled = true;
            effortLevel = "medium";

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
                "Bash(rm -rf:*)"
              ];
            };

            env = let
              _model = "nvidia/nemotron-3-ultra-550b-a55b:free";
            in {
              ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
              # ANTHROPIC_BASE_URL = "https://openrouter.ai/api";
              API_TIMEOUT_MS = 3000000;
              DISABLE_TELEMETRY = 1;
              CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
              CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY = 1;
              DISABLE_AUTOUPDATER = 1;
              MAX_THINKING_TOKENS = 10000;
              CLAUDE_CODE_AUTO_COMPACT_WINDOW = "1000000";
              ANTHROPIC_DEFAULT_HAIKU_MODEL = "glm-4.7";
              ANTHROPIC_DEFAULT_SONNET_MODEL = "glm-5.2[1m]";
              ANTHROPIC_DEFAULT_OPUS_MODEL = "glm-5.2[1m]";
              # ANTHROPIC_DEFAULT_FABLE_MODEL = model;
              # ANTHROPIC_DEFAULT_OPUS_MODEL = model;
              # ANTHROPIC_DEFAULT_SONNET_MODEL = model;
              # ANTHROPIC_DEFAULT_HAIKU_MODEL = model;
              # CLAUDE_CODE_SUBAGENT_MODEL = model;
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
            source = "${inputs.claude-agents.outPath}";
          };
        };
      };
    };
  };
}
