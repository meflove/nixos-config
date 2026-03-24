{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      hm = {
        home.packages = with pkgs; [
          dbeaver-bin
          sqlite
          postgresql
        ];
      };
    };
  };
}
