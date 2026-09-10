{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      pkgs,
      ...
    }: {
      sops = {
        secrets = lib.flattenSecrets {
          pass = {
            mode = "0444";
          };
        };
      };
      environment = {
        extraInit = ''
          if [ -f ${config.nix-secrets.secrets.pass.path} ]; then
            export GOPASS_AGE_PASSWORD=$(cat ${config.nix-secrets.secrets.pass.path})
          fi
        '';
      };

      hm = {
        home.packages = [pkgs.gopass];

        programs = {
          zen-browser = {
            nativeMessagingHosts = [pkgs.gopass-jsonapi];
          };
          password-store = {
            enable = true;
            package = pkgs.gopass;
            settings = {
              PASSWORD_STORE_DIR = "${config.hm.xdg.dataHome}/gopass/stores/root";
              PASSWORD_STORE_KEY = "";
            };
          };
        };
      };
    };
  };
}
