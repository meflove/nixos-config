{
  flake-file.inputs = {
    files.url = "github:sini/files";
  };

  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: let
    treefmt = lib.getExe config.treefmt.build.wrapper;

    claude-format-hook =
      pkgs.writers.writeBashBin "claude-format-hook"
      # bash
      ''
        json_input=$(cat)

        file_path=$(echo "$json_input" | ${lib.getExe pkgs.jq} -r '.tool_input.file_path // empty')

        # Exit silently if no file path found or file doesn't exist
        if [ -z "$file_path" ] || [ ! -f "$file_path" ]; then
          exit 0
        fi

        # Always exit 0 to avoid blocking Claude's operations.
        ${treefmt} "$file_path" &> /dev/null || true
      ''
      |> lib.getExe;
  in {
    files = {
      generateApp = true;
      treefmt.enable = true;

      file = {
        ".claude/settings.json".json = {
          hooks.PostToolUse = [
            {
              matcher = "Edit|MultiEdit|Write";
              hooks = [
                {
                  type = "command";
                  command = claude-format-hook;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
