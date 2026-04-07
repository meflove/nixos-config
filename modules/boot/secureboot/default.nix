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
            # TODO: uncomment when https://github.com/nix-community/lanzaboote/issues/569 gets fixed
            autoReboot = false;
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
