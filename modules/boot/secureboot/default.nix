{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      ...
    }: {
      boot = {
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/secureboot";
          autoGenerateKeys.enable = true;
          autoEnrollKeys = {
            enable = true;
            autoReboot = true;
          };
        };

        loader = {
          systemd-boot.enable = lib.mkForce false;
          efi = {
            efiSysMountPoint = "/efi";
            canTouchEfiVariables = true;
          };
        };
      };

      environment.systemPackages = with pkgs; [sbctl];
    };
  };
}
