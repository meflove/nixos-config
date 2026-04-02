{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        curl
        dig
        wget
        nmap
        httpie
        xh
        mtr
      ];
    };
  };
}
