{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) git-lfs;
  # git-lfs-hook = stage: {
  #   enable = true;
  #   name = "git-lfs-${stage}";
  #   entry = "${lib.getExe git-lfs} ${stage}";
  #   language = "system";
  #   pass_filenames = false;
  #   stages = [stage];
  # };
in {
  name = "nixland";

  packages = with pkgs; [
    glow # for md files
    sops # secret management
    git-lfs # git large file storage
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
      statix.enable = true;
    };
    # Git LFS hooks
    # // (builtins.listToAttrs (map (stage: {
    #   name = "git-lfs-${stage}";
    #   value = git-lfs-hook stage;
    # }) ["pre-push" "post-checkout" "post-commit" "post-merge"]));
  };
}
