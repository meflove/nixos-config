{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      pkgs,
      ...
    }: {
      hm = {
        programs = {
          jjui.enable = true;
          delta = {
            enable = true;
            enableJujutsuIntegration = true;
          };
          jujutsu = {
            enable = true;
            settings = {
              inherit (config.hm.programs.git.settings) user;
              ui = {
                editor = lib.getExe pkgs.nixCats;
              };
              git = {
                fetch = "origin";
                push = "origin";
              };
            };
          };
        };
      };
    };
  };
}
