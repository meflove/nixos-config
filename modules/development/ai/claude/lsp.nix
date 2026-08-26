{
  pkgs,
  lib,
  ...
}: {
  hm.programs.claude-code.lspServers = {
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
}
