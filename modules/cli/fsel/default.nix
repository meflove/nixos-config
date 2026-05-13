{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      ...
    }: {
      home-manager.sharedModules = [./hm-module.nix];

      hm.programs.fsel = {
        enable = true;

        settings = {
          terminal_launcher = "${lib.getExe config.environment.sessionVariables.TERMINAL} -e";
        };
      };
    };
  };
}
