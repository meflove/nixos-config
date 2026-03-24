{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      hm = {
        home.packages = with pkgs; [
          obsidian
          master.libreoffice
          papers # PDF viewer
        ];
      };
    };
  };
}
