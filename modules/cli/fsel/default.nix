{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {config, ...}: {
      home-manager.sharedModules = [./hm-module.nix];

      hm.programs.fsel = {
        enable = true;

        settings = {
          terminal_launcher = "${config.hm.programs.ghostty.package} -e";
        };
      };
    };
  };
}
