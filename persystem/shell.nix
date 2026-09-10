{inputs, ...}: {
  flake-file.inputs = {
    devenv.url = "github:cachix/devenv";
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks-nix.follows = "git-hooks";
    statix.url = "github:molybdenumsoftware/statix";
    nix2container.url = "github:nlewo/nix2container";
    flake-compat.url = "github:NixOS/flake-compat";
  };
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: {
    devenv.shells.default = {
      name = "nixland";
      env.REPO_HOST = "github";

      packages = let
        write-all =
          pkgs.writeShellScriptBin "write-all"
          # bash
          ''
            nix run .#write-flake
            nix run .#write-files
            nix fmt
          '';
      in
        lib.attrValues
        {
          inherit
            (pkgs)
            glow # for md files
            sops # secret management

            # enterShell deps
            ncurses
            ;
          inherit
            write-all # flake-files and files inputs writer
            ;
        };

      enterShell =
        # bash
        ''
          printf "\n\n%s⚙  Welcome%s to the %s NixOS %sconfiguration development %sshell!\n" \
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
          treefmt = {
            enable = true;
            package = config.treefmt.build.wrapper;
          };

          # Basic hooks
          shellcheck.enable = true;
          end-of-file-fixer.enable = true;
          detect-private-keys.enable = true;
        };
      };
    };
  };
}
