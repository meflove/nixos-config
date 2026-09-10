{
  flake-file.inputs = {
    lanzaboote.url = "github:nix-community/lanzaboote";
    ## Fix build for lanzaboote
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      pkgs,
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

      environment.systemPackages = lib.attrValues {
        inherit
          (pkgs)
          sbctl
          ;
      };
    };
  };
}
