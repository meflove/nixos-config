{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      # inputs,
      # lib,
      pkgs,
      ...
    }: {
      hm = {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;

          silent = true;
          config = {
            global = {
              strict_env = true;
              warn_timeout = "2m";
              hide_env_diff = true;
            };
          };
        };

        home.packages = [
          # inputs.devenv.packages.${lib.hostPlatform}.devenv
          pkgs.devenv
        ];
      };
    };
  };
}
