{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.boot.secureBoot;
in {
  options.${namespace}.nixos.boot.secureBoot = {
    enable =
      lib.mkEnableOption "Enable secure boot with Lanzaboote (sbctl)"
      // {
        default = false;
      };

    disableWarning = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable the warning about secure boot being enabled.";
    };
  };

  config = mkIf cfg.enable {
    warnings =
      if !cfg.disableWarning
      then [
        "⚠️ Secure Boot enabled. Read: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md"
      ]
      else [];

    boot = {
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
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
}
