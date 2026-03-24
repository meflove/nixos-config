{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
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

      environment.extraInit = ''
        if [ -f ${config.sops.secrets."github/github_auth_token".path} ]; then
          export GITHUB_TOKEN=$(cat ${config.sops.secrets."github/github_auth_token".path})
        fi
      '';

      nix = {
        package = pkgs.lix;

        nixPath = ["nixpkgs=${inputs.nixpkgs}"];
        channel.enable = false;

        settings = {
          use-xdg-base-directories = true;

          allowed-users = ["@wheel"];
          trusted-users = ["@wheel"];

          connect-timeout = 4;
          stalled-download-timeout = 4;

          substituters = [
            "https://nixos-cache-proxy.cofob.dev"
            "https://mirror.yandex.ru/nixos"
            "https://cache.nixos-cuda.org"
            "https://nix-gaming.cachix.org"
            "https://chaotic-nyx.cachix.org"
            "https://nix-community.cachix.org"
            "https://hyprland.cachix.org"
            "https://cache.garnix.io"
            "https://yazi.cachix.org"
            "https://devenv.cachix.org"
            "https://nvim-treesitter-main.cachix.org"
            "https://niri.cachix.org"
            "https://watersucks.cachix.org"
            "https://claude-code.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
            "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
            "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
            "nvim-treesitter-main.cachix.org-1:cbwE6blfW5+BkXXyeAXoVSu1gliqPLHo2m98E4hWfZQ="
            "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
            "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
            "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
          ];

          extra-experimental-features = [
            "nix-command"
            "flakes"
            "auto-allocate-uids"
            "cgroups"
            "pipe-operator" # Lix naming
          ];

          extra-deprecated-features = [
            "or-as-identifier"
            "broken-string-indentation"
          ];

          auto-allocate-uids = true;
          use-cgroups = true;

          auto-optimise-store = true;
          allow-import-from-derivation = true;

          # With Lix, i cant use this option
          # download-buffer-size = 2097152000;
        };

        extraOptions = ''
          !include ${config.sops.templates."nix-access-tokens.nix".path}
        '';
      };
    };
  };
}
