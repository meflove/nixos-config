{pkgs, ...}: {
  packages = with pkgs; [
    glow # for md files
    jq # for shellHook script
    transcrypt # for shellHook script
  ];

  name = "nixland";

  shellHook = ''
    echo -e "\n\e[33m⚙ Welcome\e[0m \e[37mto the\e[0m \e[36m NixOS\e[0m \e[35mconfiguration development\e[0m \e[32mshell!\e[0m"

    key=$(jq -r '
      .nodes
      | to_entries
      | map(select(
          .value.original.repo == "nixpkgs" and .value.original.ref == "master"
        ))
      | .[0].key
    ' flake.lock)

    timestamp=$(jq -r --arg key "$key" ".nodes[\$key].locked.lastModified" flake.lock)

    date_str=$(date -d "@$timestamp" +"%Y.%m.%d")

    echo -e "\033[36m \033[33mNixpkgs pinned in the flake.lock: \e[36m$date_str\033[0m \n"

    git status
  '';
}
