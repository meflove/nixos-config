{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      ...
    }: {
      hardware = {
        enableRedistributableFirmware = true;
        enableAllHardware = true;

        bluetooth = {
          enable = true;
          powerOnBoot = true;

          settings = {
            General = {
              Experimental = true;
              KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e";
            };
          };
        };
      };

      environment.systemPackages = lib.attrValues {
        inherit
          (pkgs)
          bluetui
          bluez-experimental
          ;
      };
    };
  };
}
