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
          wireshark
          postman
          ;
      };

      users.users = {
        ${lib.userName} = {
          extraGroups = [
            "wireshark"
          ];
        };
      };

      programs = {
        wireshark = {
          enable = true;
          dumpcap.enable = true;
          usbmon.enable = true;
        };
      };
    };
  };
}
