{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }: {
      home-manager.sharedModules = [./hm-module.nix {inherit inputs config lib pkgs;}];
      hm = {
        programs.hyprscope = {
          enable = true;

          gamescopeArgs = [
            # Enable adaptive sync
            "--adaptive-sync"
          ];

          gamemodeIntegration = true;
        };
      };
    };
  };
}
