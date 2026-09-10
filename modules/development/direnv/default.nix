{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      pkgs,
      ...
    }: {
      nix-secrets = {
        secrets = {
          cachix_auth_token = {
            mode = "0644";
          };
        };
      };
      sops = {
        secrets = {
          cachix_auth_token = {
            mode = "0644";
          };
        };
      };
      environment = {
        extraInit = ''
          if [ -f ${config.nix-secrets.secrets.cachix_auth_token.path} ]; then
            export CACHIX_AUTH_TOKEN=$(cat ${config.nix-secrets.secrets.cachix_auth_token.path})
          fi
        '';
      };
      hm = {
        programs = {
          direnv = {
            enable = true;
            nix-direnv.enable = true;
            enableFishIntegration = true;
            enableNushellIntegration = true;

            silent = true;
            config = {
              global = {
                strict_env = true;
                warn_timeout = "2m";
                hide_env_diff = true;
              };
            };
          };
          devenv = {
            enable = true;
            enableFishIntegration = true;
            enableNushellIntegration = true;
          };
        };

        home.packages = lib.attrValues {
          inherit
            (pkgs)
            cachix
            ;
        };
      };
    };
  };
}
