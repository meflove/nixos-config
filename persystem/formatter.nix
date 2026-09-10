{
  flake-file.inputs = {
    treefmt-nix.url = "github:numtide/treefmt-nix";
    pedantix.url = "github:swarsel/pedantix";
  };
  perSystem = {
    lib,
    pkgs,
    extendedLib,
    inputs',
    ...
  }: let
    # TODO: drop the wrapper once pedantix supports |>
    pedantix-forgiving = pkgs.writeShellScriptBin "pedantix" ''
      code=0
      ${lib.getExe inputs'.pedantix.packages.pedantix-wrapped} "$@" || code=$?
      if [ "$code" -eq 2 ]; then
        exit 0
      fi
      exit "$code"
    '';

    toKDL = extendedLib.homeLib.hm.generators.toKDL {};

    kdlfmt-config = pkgs.writeText "kdlfmt.kdl" (toKDL {
      indent_size = 2;
      use_tabs = false;
    });

    kdlfmt-with-config =
      pkgs.writeShellScriptBin "kdlfmt"
      # bash
      ''
        exec ${lib.getExe pkgs.kdlfmt} \
          format \
          --config=${kdlfmt-config} \
          "$@"
      '';
  in {
    treefmt = {
      settings = {
        global = {
          on-unmatched = "warn";
          excludes = [
            "secrets/*"
            "nix-secrets/*"
            "pics/*"
            ".sops.yaml"
            ".gitignore"
            ".envrc"
          ];
        };
        formatter = {
          # kdl
          "kdlfmt-with-config" = {
            command = "${pkgs.bash}/bin/bash";
            options = [
              "-euc"
              ''
                for file in "$@"; do
                  ${lib.getExe kdlfmt-with-config} $file
                done
              ''
              "--" # bash swallows the second argument when using -c
            ];
            includes = ["*.kdl"];
          };
        };
      };
      programs = {
        # nix
        alejandra = {
          enable = true;
          priority = 1;
          includes = [
            "*.nix"
          ];
        };

        pedantix = {
          enable = true;
          priority = 2;
          package = pedantix-forgiving;
          includes = [
            "*.nix"
          ];
          settings = {
            preset = "nixos-module";
            formatter = "alejandra";

            args = {
              sort = true;
            };
            attrs = {
              sort = false;
            };
            inherits = {
              sort = false;
            };
            lets = {
              sort = false;
            };
          };
        };

        statix = {
          enable = true;
          priority = 3;
          includes = [
            "*.nix"
          ];
        };

        deadnix = {
          enable = true;
          priority = 4;
          includes = [
            "*.nix"
          ];

          no-underscore = true;
        };

        # md
        prettier = {
          enable = true;
          includes = [
            "*.md"
          ];
        };

        # json
        jsonfmt = {
          enable = true;
          includes = [
            "*.json"
            "*.jsonc"
          ];
        };

        # py
        ruff-format = {
          enable = true;
          includes = [
            "*.py"
          ];
        };

        # toml
        taplo = {
          enable = true;
          includes = [
            "*.toml"
          ];
        };

        # yaml
        yamlfmt = {
          enable = true;
          includes = [
            "*.yaml"
            "*.yml"
          ];

          settings = {
            formatter = {
              include_document_start = true;
            };
          };
        };
      };
    };
  };
}
