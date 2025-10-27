{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.development.virtManager;
in {
  options.${namespace}.nixos.development.virtManager = {
    enable =
      lib.mkEnableOption "enable virt-manager and libvirtd for virtual machine management"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;

        vhostUserPackages = with pkgs; [virtiofsd];
      };
    };
    programs.virt-manager.enable = true;

    users.users.angeldust.extraGroups = ["libvirtd"];
  };
}
