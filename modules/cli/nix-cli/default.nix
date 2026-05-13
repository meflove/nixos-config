{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      lib,
      ...
    }: {
      environment = {
        sessionVariables.NIXOS_CONFIG = lib.flakeDir;
        systemPackages = lib.attrValues {
          inherit
            (pkgs)
            # Nix related tools
            nix-output-monitor
            nix-update
            ;
        };
      };

      programs = {
        nh = {
          enable = true;
          package = inputs.nh.packages.${lib.hostPlatform}.default;

          flake = lib.flakeDir;

          clean = {
            enable = true;
            dates = "weekly";
            extraArgs = "--keep-since 7d --keep 10";
          };
        };

        nixos-cli = {
          enable = true;
          package = pkgs.nixos-cli;

          option-cache.enable = true;
          settings = {
            config_location = "${lib.flakeDir}#${lib.configurationName}";

            differ = {
              tool = "command";
              command = [(lib.getExe pkgs.nvd) "diff"];
            };
            apply = {
              ignore_dirty_tree = true;
              reexec_as_root = true;
              use_nom = true;
            };
            rollback.enable = true;
          };
        };

        nix-index = {
          enableFishIntegration = true;
        };
        nix-index-database = {
          enable = true;
          comma.enable = true;
        };
      };
    };
  };
}
