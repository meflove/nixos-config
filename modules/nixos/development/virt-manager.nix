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
    boot = {
      kernelParams = [
        "intel_iommu=on"
        "vfio-pci.ids=1002:67b0,1002:aac8,144d:a80a"
      ];

      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
    };

    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_full;
          runAsRoot = true;
          swtpm.enable = true;

          vhostUserPackages = with pkgs; [virtiofsd];
        };

        firewallBackend = "nftables";
      };
    };
    programs.virt-manager.enable = true;
    security.polkit.enable = true;

    users.users.angeldust.extraGroups = ["libvirtd" "kvm"];
  };
}
