{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      ...
    }: {
      environment.systemPackages = lib.attrValues {
        inherit
          (pkgs)
          curl
          dig
          wget
          nmap
          httpie
          xh
          mtr
          net-tools
          ;
      };
    };
  };
}
