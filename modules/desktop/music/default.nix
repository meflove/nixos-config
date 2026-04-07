{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      hm = {
        home.packages = with pkgs; [
          mefPkgs.soundcloud-desktop
          # master.cliamp
        ];
      };
    };
  };
}
