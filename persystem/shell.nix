{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    devenv.shells.default = {
      name = "nixland";

      packages = lib.attrValues {
        inherit
          (pkgs)
          glow # for md files
          sops # secret management

          # enterShell deps
          ncurses
          ;
      };

      enterShell =
        # bash
        ''
          printf "%s⚙  Welcome%s to the %s NixOS %sconfiguration development %sshell!\n" \
            "$(tput setaf 3)" \
            "$(tput sgr0)" \
            "$(tput setaf 6)" \
            "$(tput setaf 5)" \
            "$(tput setaf 2)"

          timestamp=${toString inputs.nixpkgs.sourceInfo.lastModified}
          rev=${toString inputs.nixpkgs.sourceInfo.shortRev}
          url=https://github.com/NixOS/nixpkgs/tree/$rev
          date_str=$(date -d "@$timestamp" +"%d.%m.%Y")

          printf "%s%s %sNixpkgs pinned in the flake.lock:%s %s\e]8;;$url\a$rev\e]8;;\a%s ($date_str)\n\n" \
            "$(tput setaf 6 bold)" \
            "$(tput sgr0)" \
            "$(tput setaf 3)" \
            "$(tput sgr 0)" \
            "$(tput setaf 6 bold)"\
            "$(tput sgr0)"

          ${lib.getExe pkgs.jujutsu} status --no-pager
        '';

      git-hooks = {
        package = pkgs.prek;

        hooks = {
          # Basic hooks
          shellcheck.enable = true;
          end-of-file-fixer.enable = true;
          detect-private-keys.enable = true;

          # Nix specific hooks
          alejandra.enable = true;
          deadnix = {
            enable = true;
            settings.noUnderscore = true;
          };
          statix.enable = true;
        };
      };
    };
  };
}
