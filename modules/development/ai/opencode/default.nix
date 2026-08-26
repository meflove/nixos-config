{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      inputs,
      pkgs,
      lib,
      config,
      ...
    }: let
      opencode = pkgs.llm-agents.opencode2;
      opencode-wrapped = pkgs.symlinkJoin {
        pname = "opencode-wrapped";
        version = lib.getVersion opencode;
        meta.mainProgram = "opencode2";
        paths = [opencode pkgs.python3 pkgs.ast-grep];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          ln -s $out/bin/opencode2 $out/bin/opencode
          wrapProgram $out/bin/opencode \
            --run 'export ANTHROPIC_AUTH_TOKEN=$(cat ${config.hm.sops.secrets."ai/zai_api_key".path})' \
            --run 'export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.hm.sops.secrets."github/github_pat".path})' \
            --run 'export CONTEXT7_API_KEY=$(cat ${config.hm.sops.secrets."mcp/context7_api_key".path})' \
            --run 'export HUGGINGFACE_API_KEY=$(cat ${config.hm.sops.secrets."mcp/huggingface_api_key".path})' \
            --set OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS true \
            --set OPENCODE_ENABLE_EXA 1
        '';
      };
    in {
      services.ollama = {
        enable = true;
        loadModels = [
          "qwen3-embedding:4b"
        ];
      };
      hm = {
        sops = {
          secrets = lib.flattenSecrets {
            ai = {
              zai_api_key = {};
            };
          };
        };
        programs.opencode = {
          enable = true;
          package = opencode-wrapped;

          enableMcpIntegration = true;

          context = ./AGENTS.md;

          commands = ./commands;
          agents = inputs.claude-agents.outPath;

          # not working for now, due to opencode v2
          # nixPlugins = {
          #   oh-my-opencode-slim = {
          #     enable = true;
          #     settings = {
          #       preset = "zai";
          #       presets.zai = {
          #         orchestrator = {
          #           model = "zai-coding-plan/glm-5.3";
          #           variant = "max";
          #           skills = ["*"];
          #           mcps = [
          #             "*"
          #             "!context7"
          #           ];
          #         };
          #         oracle = {
          #           model = "zai-coding-plan/glm-5.3";
          #           variant = "max";
          #           mcps = [];
          #         };
          #         librarian = {
          #           model = "zai-coding-plan/glm-5.3-flash";
          #           skills = [];
          #           mcps = [
          #             "context7"
          #             "github"
          #             "nixos"
          #           ];
          #         };
          #         explorer = {
          #           model = "zai-coding-plan/glm-5.3-flash";
          #           skills = [];
          #           mcps = [];
          #         };
          #         designer = {
          #           model = "zai-coding-plan/glm-5.3-flash";
          #           skills = [];
          #           mcps = [];
          #         };
          #         fixer = {
          #           model = "zai-coding-plan/glm-5.3-flash";
          #           skills = [];
          #           mcps = [];
          #         };
          #       };
          #     };
          #   };
          #   opencode-dynamic-context-pruning = {
          #     enable = true;
          #     settings = {
          #       compress = {
          #         mode = "message";
          #
          #         permission = "ask";
          #
          #         maxContextLimit = "60%";
          #         minContextLimit = "30%";
          #
          #         protectUserMessages = true;
          #       };
          #     };
          #   };
          #   opencode-notify = {
          #     enable = true;
          #     settings = {
          #       terminal = "kitty";
          #     };
          #   };
          #
          #   opencode-mem = {
          #     enable = true;
          #     settings = {
          #       autoCaptureEnabled = true;
          #       autoCaptureLanguage = "auto";
          #
          #       opencodeProvider = "zai-coding-plan";
          #       opencodeModel = "glm-5.3-flash";
          #
          #       embeddingApiUrl = "http://127.0.0.1:11434/v1";
          #       embeddingApiKey = "ollama"; # any non-empty stub
          #       embeddingModel = "qwen3-embedding:4b";
          #       # auto-detect doesn't know ollama tags (defaults 768) — must be explicit:
          #       embeddingDimensions = 2560;
          #     };
          #   };
          # };

          settings = {
            shell = lib.getExe pkgs.bashInteractive;
            autoupdate = false;

            plugins = [
              "opencode-direnv"
            ];
            formatter = {
              nix-fmt = {
                command = [
                  "nix"
                  "fmt"
                  "$FILE"
                ];
              };
              extensions = [
                ".nix"
                ".md"
                ".json"
                ".kdl"
                ".py"
                ".toml"
                ".yaml"
                ".yml"
              ];
            };
            permissions = let
              shellHelper = command: effect: {
                inherit effect;
                action = "shell";
                resource = "${command} *";
              };
              vcsHelper = vcs: action: effect:
                (map (
                    _vcs:
                      map (
                        _action: shellHelper "${_vcs} ${_action}" effect
                      )
                      action
                  )
                  vcs)
                |> lib.flatten;
            in [
              {
                action = "edit";
                resource = "*";
                effect = "ask";
              }
              {
                action = "webfetch";
                resource = "*";
                effect = "allow";
              }
              {
                action = "read";
                resource = "*";
                effect = "allow";
              }
              {
                action = "read";
                resource = "/*";
                effect = "allow";
              }
              {
                action = "read";
                resource = "/nix/store/*";
                effect = "allow";
              }
              {
                action = "grep";
                resource = "*";
                effect = "allow";
              }
              {
                action = "glob";
                resource = "*";
                effect = "allow";
              }
              {
                action = "lsp";
                resource = "*";
                effect = "allow";
              }
              {
                action = "skill";
                resource = "*";
                effect = "allow";
              }
              (
                ["ls" "echo" "grep" "head" "tail" "cd" "cat" "nix"]
                |> map (command:
                  shellHelper command "allow")
              )
              (
                vcsHelper ["jj" "git"] [""] "ask"
              )
              (
                vcsHelper ["jj" "git"] ["commit"] "ask"
              )
              (
                vcsHelper ["jj"] ["new" "desc"] "ask"
              )
              (
                vcsHelper ["jj" "git"] ["status" "diff" "log" "show"] "allow"
              )
            ];

            lsp = {
              nixd = {
                command = [(lib.getExe pkgs.nixd)];
                extensions = [
                  ".nix"
                ];
              };
              pyright = {
                command = [
                  (lib.getExe' pkgs.basedpyright "basedpyright-langserver")
                  "--stdio"
                ];
                extensions = [
                  ".py"
                  ".pyi"
                ];
              };
              rust-analyzer = {
                command = [(lib.getExe pkgs.rust-analyzer)];
                extensions = [
                  ".rs"
                ];
              };
              typescript = {
                command = [
                  (lib.getExe pkgs.typescript-language-server)
                  "--stdio"
                ];
                extensions = [
                  ".js"
                  ".jsx"
                  ".ts"
                  ".tsx"
                ];
              };
              bashls = {
                command = [
                  (lib.getExe pkgs.bash-language-server)
                  "start"
                ];
                extensions = [
                  ".sh"
                  ".bash"
                  ".zsh"
                ];
              };
              clangd = {
                command = [
                  (lib.getExe' pkgs.clang-tools "clangd")
                  "--background-index"
                ];
                extensions = [
                  ".c"
                  ".h"
                  ".cpp"
                  ".cc"
                  ".cxx"
                  ".hpp"
                  ".hxx"
                  ".C"
                  ".H"
                ];
              };
              lua_ls = {
                command = [(lib.getExe pkgs.lua-language-server)];
                extensions = [
                  ".lua"
                ];
              };
              marksman = {
                command = [
                  (lib.getExe pkgs.marksman)
                  "server"
                ];
                extensions = [
                  ".md"
                ];
              };
              jsonls = {
                command = [
                  (lib.getExe' pkgs.vscode-json-languageserver "vscode-json-language-server")
                  "--stdio"
                ];
                extensions = [
                  ".json"
                  ".jsonc"
                ];
              };
              yamlls = {
                command = [
                  (lib.getExe pkgs.yaml-language-server)
                  "--stdio"
                ];
                extensions = [
                  ".yaml"
                ];
              };
            };
          };
        };
      };
    };
  };
}
