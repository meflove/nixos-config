{
  flake = {lib, ...}: let
    nixosOrgKey = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";

    caches = [
      {
        url = "https://mirror.yandex.ru/nixos";
        public_key = nixosOrgKey;
      }
      {
        url = "https://nixos-cache-proxy.cofob.dev";
        public_key = nixosOrgKey;
      }
      {
        url = "https://nix-gaming.cachix.org";
        public_key = "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
      }
      {
        url = "https://chaotic-nyx.cachix.org";
        public_key = "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8=";
      }
      {
        url = "https://nix-community.cachix.org";
        public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      }
      {
        url = "https://hyprland.cachix.org";
        public_key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
      }
      {
        url = "https://yazi.cachix.org";
        public_key = "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=";
      }
      {
        url = "https://devenv.cachix.org";
        public_key = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
      }
      {
        url = "https://nvim-treesitter-main.cachix.org";
        public_key = "nvim-treesitter-main.cachix.org-1:cbwE6blfW5+BkXXyeAXoVSu1gliqPLHo2m98E4hWfZQ=";
      }
      {
        url = "https://niri.cachix.org";
        public_key = "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=";
      }
      {
        url = "https://watersucks.cachix.org";
        public_key = "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8=";
      }
      {
        url = "https://claude-code.cachix.org";
        public_key = "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk=";
      }
      {
        url = "https://meflove.cachix.org";
        public_key = "meflove.cachix.org-1:daXeLaZBNNJOngNUDEoylRfvtai2uSFOqdg29fN+7N8=";
      }
      {
        url = "https://nixpkgs-unfree.cachix.org";
        public_key = "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs=";
      }
      # {
      #   url = "https://cache.nixos-cuda.org";
      #   public_key = "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=";
      #
      # }
      {
        url = "https://cache.nixos.org";
        public_key = nixosOrgKey;
      }
    ];
  in {
    nixConfig = {
      extra-substituters = map (cache: cache.url) caches;
      extra-trusted-public-keys = lib.unique (map (cache: cache.key) caches);
      extra-experimental-features = ["pipe-operators"];
    };

    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      inputs,
      self,
      ...
    }: {
      sops = {
        secrets = lib.flattenSecrets {
          github = {
            github_pat = {
              mode = "0444";
            };
          };
        };

        templates = {
          "nix-access-tokens.nix".content = ''
            access-tokens = "github.com=${config.sops.placeholder."github/github_pat"}";
          '';
        };
      };

      environment = {
        etc = {
          "determinate/config.json".text = lib.toJSON {garbageCollector.strategy = "disabled";};
        };

        extraInit = ''
          if [ -f ${config.sops.secrets."github/github_pat".path} ]; then
            export GITHUB_TOKEN=$(cat ${config.sops.secrets."github/github_pat".path})
          fi
        '';
      };

      nix = {
        channel.enable = false;
        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
          "nixos-config=${self}"
        ];
        registry =
          (lib.mapAttrs (_: value: {
              flake = value;
            })
            inputs)
          // {
            self.flake = self;
          };

        settings = {
          substituters = lib.mkForce [
            "http://localhost${config.services.ncro.settings.server.listen}"
          ];

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
            # "pipe-operators"
            "pipe-operator" # lix
          ];

          auto-allocate-uids = true;
          use-cgroups = true;

          auto-optimise-store = true;
          allow-import-from-derivation = true;

          # download-buffer-size = 2048 * 1024 * 1024; # 2 GB
        };

        extraOptions = ''
          !include ${config.sops.templates."nix-access-tokens.nix".path}
        '';
      };

      services.ncro = {
        enable = true;
        settings = {
          server.listen = ":9600";
          upstreams =
            map (cache: {
              inherit (cache) url public_key;
              priority =
                if cache.url == "https://cache.nixos.org"
                then 100
                else if cache.url == "https://nixos-cache-proxy.cofob.dev"
                then 20
                else if cache.url == "https://mirror.yandex.ru/nixos"
                then 10
                else 30;
            })
            caches;
        };
      };
    };
  };
}
