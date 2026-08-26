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
      # Wrapped claude-code package that injects secrets as environment variables
      opencode-wrapped = pkgs.symlinkJoin {
        pname = "opencode-wrapped";
        version = lib.getVersion opencode;
        meta.mainProgram = "opencode2";
        paths = [opencode pkgs.python3];
        buildInputs = [pkgs.makeWrapper];
        # --run 'export ANTHROPIC_API_KEY=$(cat ${config.hm.sops.secrets."ai/openrouter_api_key".path})' \
        postBuild = ''
          wrapProgram $out/bin/opencode2 \
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
        programs.opencode = {
          enable = true;
          package = opencode-wrapped;

          enableMcpIntegration = true;

          context = ./AGENTS.md;

          commands = ./commands;
          skills = ./skills;
          agents = inputs.claude-agents.outPath;

          settings = {
            formatter = {
              nix-fmt = {
                command = ["nix" "fmt" "$FILE"];
              };
              extensions = [
                ".nix"
                ".md"
              ];
            };
            permissions = [
              {
                action = "edit";
                resource = "*";
                effect = "ask";
              }
              {
                action = "bash";
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
              {
                action = "todowrite";
                resource = "*";
                effect = "allow";
              }
              {
                action = "question";
                resource = "*";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "*";
                effect = "ask";
              }
              ((map (
                  vcs:
                    map (
                      action: {
                        action = "shell";
                        resource = "${vcs} ${action} *";
                        effect = "allow";
                      }
                    ) ["status" "diff" "log"]
                ) ["jj" "git"])
                |> lib.flatten)
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
