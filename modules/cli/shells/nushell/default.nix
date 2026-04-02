{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      pkgs,
      config,
      ...
    }: {
      hm = {
        programs = {
          nushell = {
            enable = true;
            # for editing directly to config.nu
            extraConfig = ''
              def fish-run [cmd: string] {
                  ^${lib.getExe config.hm.programs.fish.package} -c $cmd
              }
            '';
            shellAliases = {
              n = lib.getExe pkgs.nixCats;
            };
          };
          carapace = {
            enable = true;
            enableNushellIntegration = true;
          };
        };
      };
    };
  };
}
