{
  pkgs,
  lib,
  ...
}: {
  name = "nixland";

  packages = with pkgs; [
    glow # for md files
    transcrypt # for shellHook script
  ];

  enterShell = ''
    echo -e "\n\e[33m⚙ Welcome\e[0m \e[37mto the\e[0m \e[36m NixOS\e[0m \e[35mconfiguration development\e[0m \e[32mshell!\e[0m"

    key=$(${lib.getExe pkgs.jq} -r '
      .nodes
      | to_entries
      | map(select(
          .value.original.repo == "nixpkgs" and .value.original.ref == "master"
        ))
      | .[0].key
    ' flake.lock)

    timestamp=$(${lib.getExe pkgs.jq} -r --arg key "$key" ".nodes[\$key].locked.lastModified" flake.lock)

    date_str=$(date -d "@$timestamp" +"%Y.%m.%d")

    echo -e "\033[36m \033[33mNixpkgs pinned in the flake.lock: \e[36m$date_str\033[0m \n"

    ${lib.getExe pkgs.git} status
  '';

  scripts.transcrypt-hook = {
    exec = ''
      #!${lib.getExe pkgs.bash}

      # Transcrypt pre-commit hook: fail if secret file in staging lacks the magic prefix "Salted" in B64
      RELATIVE_GIT_DIR=$(${lib.getExe pkgs.git} rev-parse --git-dir 2>/dev/null || printf "")
      CRYPT_DIR=$(${lib.getExe pkgs.git} config transcrypt.crypt-dir 2>/dev/null || printf "%s/crypt" "''${RELATIVE_GIT_DIR}")

      printf "\nRunning transcrypt pre-commit hook...\n\n"
      "''${CRYPT_DIR}/transcrypt" pre_commit
    '';
  };

  git-hooks = {
    package = pkgs.prek;

    hooks = {
      # Basic hooks
      shellcheck.enable = true;
      end-of-file-fixer.enable = true;
      trim-trailing-whitespace.enable = true;
      detect-private-keys.enable = true;

      # Nix specific hooks
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;

      # Secret management hooks
      transcrypt = {
        enable = true;

        name = "transcrypt-hook";
        entry = "transcrypt-hook";
      };
    };
  };
}
