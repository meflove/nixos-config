{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      boot = {
        kernelParams = [
          "intel_iommu=on"
          "vfio-pci.ids=1002:67b0,1002:aac8,144d:a80a"
        ];

        kernelModules = [
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
            package = pkgs.qemu;
            runAsRoot = true;
            swtpm.enable = true;

            vhostUserPackages = with pkgs; [virtiofsd];
          };

          firewallBackend = "nftables";
        };
      };
      programs.virt-manager.enable = true;
      security.polkit.enable = true;

      environment.sessionVariables = {
        LIBVIRT_DEFAULT_URI = "qemu:///system";
      };
    };
  };
}
