{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      inputs,
      ...
    }: {
      sops = {
        secrets = lib.flattenSecrets {
          github = {
            github_auth_token = {
              mode = "0444";
            };
          };
        };

        templates = {
          "nix-access-tokens.nix".content = ''
            access-tokens = "github.com=${config.sops.placeholder."github/github_auth_token"}";
          '';
        };
      };

      environment = {
        etc = {
          "determinate/config.json".text = lib.toJSON {garbageCollector.strategy = "disabled";};
        };

        extraInit = ''
          if [ -f ${config.sops.secrets."github/github_auth_token".path} ]; then
            export GITHUB_TOKEN=$(cat ${config.sops.secrets."github/github_auth_token".path})
          fi
        '';
      };

      nix = {
        nixPath = ["nixpkgs=${inputs.nixpkgs}"];
        channel.enable = false;

        settings = {
          substituters = inputs.self.nixConfig.extra-substituters;
          trusted-public-keys = inputs.self.nixConfig.extra-trusted-public-keys;
          connect-timeout = 5;
          stalled-download-timeout = 10;

          use-xdg-base-directories = true;

          allowed-users = ["@wheel"];
          trusted-users = ["@wheel"];

          extra-experimental-features = [
            "nix-command"
            "flakes"
            "auto-allocate-uids"
            "cgroups"
            "pipe-operators"
          ];

          auto-allocate-uids = true;
          use-cgroups = true;

          auto-optimise-store = true;
          allow-import-from-derivation = true;

          download-buffer-size = 2048 * 1024 * 1024; # 2 GB
        };

        extraOptions = ''
          !include ${config.sops.templates."nix-access-tokens.nix".path}
        '';
      };
    };
  };
}
