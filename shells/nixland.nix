{
  perSystem = {
    pkgs,
    lib,
    inputs',
    ...
  }: {
    devenv.shells.default = {
      name = "nixland";

      packages = with pkgs; [
        glow # for md files
        sops # secret management
        bun
        inputs'.bun2nix.packages.default
      ];

      enterShell = ''
        echo -e "\n\e[33m⚙ Welcome\e[0m \e[37mto the\e[0m \e[36m NixOS\e[0m \e[35mconfiguration development\e[0m \e[32mshell!\e[0m"

        key=$(${lib.getExe pkgs.jq} -r '
          .nodes
          | to_entries
          | map(select(
              .value.original.ref == "nixos-unstable" and
              (.value.original.owner == "NixOS" and .value.original.repo == "nixpkgs")
            ))
          | .[0].key
        ' flake.lock)

        if [ -n "$key" ] && [ "$key" != "null" ]; then
          timestamp=$(${lib.getExe pkgs.jq} -r --arg key "$key" ".nodes[\$key].locked.lastModified" flake.lock)

          if [ -n "$timestamp" ] && [ "$timestamp" != "null" ] && [ "$timestamp" != "" ]; then
            date_str=$(date -d "@$timestamp" +"%Y.%m.%d" 2>/dev/null)

            if [ $? -eq 0 ] && [ -n "$date_str" ]; then
              echo -e "\033[36m \033[33mNixpkgs pinned in the flake.lock: \e[36m$date_str\033[0m \n"
            else
              echo -e "\033[36m \033[33mNixpkgs timestamp: \e[36m$timestamp\033[0m \n"
            fi
          else
            echo -e "\033[33m⚠ Could not determine Nixpkgs timestamp\033[0m \n"
          fi
        else
          echo -e "\033[33m⚠ Could not find nixpkgs node in flake.lock\033[0m \n"
        fi

        ${lib.getExe pkgs.git} status
      '';

      git-hooks = {
        package = pkgs.prek;

        default_stages = [
          "pre-commit"
          "pre-push"
          "post-checkout"
          "post-commit"
          "post-merge"
        ];

        hooks = {
          # Basic hooks
          shellcheck.enable = true;
          end-of-file-fixer.enable = true;
          trim-trailing-whitespace.enable = true;
          detect-private-keys.enable = true;

          # Nix specific hooks
          alejandra.enable = true;
          deadnix.enable = true;
          statix = {
            enable = true;
            package = inputs'.statix.packages.statix;
          };
        };
      };
    };
  };
}
