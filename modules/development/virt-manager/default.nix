{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      ...
    }: {
      boot = {
        kernelParams = [
          "intel_iommu=on"
        ];
        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ];
      };

      users.users = {
        ${lib.userName} = {
          extraGroups = [
            "libvirtd"
            "kvm"
          ];
        };
      };

      virtualisation = {
        spiceUSBRedirection.enable = true;
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;

            vhostUserPackages = lib.attrValues {
              inherit
                (pkgs)
                virtiofsd
                ;
            };
          };

          firewallBackend = "nftables";
        };
      };

      programs.virt-manager.enable = true;
      security.polkit.enable = true;

      networking.firewall.trustedInterfaces = ["virbr0"];
      environment = {
        systemPackages = lib.attrValues {
          inherit
            (pkgs)
            dnsmasq
            ;
        };
        sessionVariables = {
          LIBVIRT_DEFAULT_URI = "qemu:///system";
        };
      };
    };
  };
}
