{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      inputs,
      ...
    }: {
      services.scx = {
        enable = true;
        package = pkgs.scx.rustscheds;

        scheduler = "scx_lavd";
        extraArgs = [
          "--performance"
          "--no-core-compaction"
          "--per-cpu-dsq"
        ];
      };

      boot = let
        consoleLogLevel = 3;

        kernel = pkgs.cachyosKernels.linux-cachyos-latest.override {
          pname = "linux-cachyos-lto-x86_64-v3";

          cpusched = "bore";
          performanceGovernor = true;
          tickrate = "full";
          lto = "thin";
          processorOpt = "x86_64-v3";
          autofdo = true;
          bbr3 = true;
        };

        kernelPackages = (pkgs.linuxKernel.packagesFor kernel).extend (final: prev: {
          zfs_cachyos = final.callPackage "${inputs.nix-cachyos-kernel.outPath}/zfs-cachyos" {
            inherit (inputs.nix-cachyos-kernel) inputs;
            variant = "linux-cachyos";
          };

          nvidiaPackages =
            prev.nvidiaPackages
            // {
              latest = prev.nvidiaPackages.latest.overrideAttrs (_: previous: {
                passthru =
                  previous.passthru
                  // {
                    open = previous.passthru.open.overrideAttrs (_: p: {
                      patches = (p.patches or []) ++ [./nvidia-open-gpio-const.patch];
                    });
                  };
              });
            };
        });
      in {
        inherit kernelPackages;
        # kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

        kernelPatches = [
          {
            name = "optimisations";
            patch = null;
            features = {
              optimization = true;
              microcode = true;
            };
          }
          {
            name = "bbr_net_sched";
            patch = null;
            structuredExtraConfig = with pkgs.lib.kernel; {
              TCP_CONG_CUBIC = lib.mkForce module;
              DEFAULT_CUBIC = no;
              TCP_CONG_BBR = yes;
              DEFAULT_BBR = yes;
              DEFAULT_TCP_CONG = freeform "bbr";
              NET_SCH_FQ_CODEL = module;
              NET_SCH_FQ = yes;
              CONFIG_DEFAULT_FQ_CODEL = no;
              CONFIG_DEFAULT_FQ = yes;
            };
          }
          {
            name = "disable_brk";
            patch = null;
            structuredExtraConfig = with pkgs.lib.kernel; {
              COMPAT_BRK = no;
            };
          }
          {
            name = "nohz_full";
            patch = null;
            structuredExtraConfig = with pkgs.lib.kernel; {
              HZ_PERIODIC = no;
              NO_HZ_IDLE = no;
              CONTEXT_TRACKING_FORCE = no;
              NO_HZ_FULL_NODEF = yes;
              NO_HZ_FULL = yes;
              NO_HZ = yes;
              NO_HZ_COMMON = yes;
              CONTEXT_TRACKING = yes;
            };
          }
        ];
        kernelModules = [
          "v4l2loopback"
        ];

        blacklistedKernelModules = ["intel_oc_wdt"];

        initrd = {
          verbose = false;
          systemd.enable = true;
        };
        plymouth.enable = true;

        inherit consoleLogLevel;
        loader.timeout = 0;

        kernel.sysctl."kernel.sysrq" = 1;
        kernelParams = [
          # Quiet / boot UI
          "quiet"
          "splash"
          "rd.systemd.show_status=auto"
          "rd.udev.log_level=${toString consoleLogLevel}"
          "udev.log_priority=${toString consoleLogLevel}"
          "vt.global_cursor_default=0"
          # "bgrt_disable"

          # Boot optimisations
          "rd.udev.timeout=0" # Don't wait for USB devices
          "8250.nr_uarts=0" # Disable serial ports (ttyS0-31)

          # Performance / hardware behavior
          "pci=pcie_bus_perf"
          "intel_idle.max_cstate=1"
          "page_alloc.shuffle=1"
          "lpj=2496000"

          # Diagnostics / noise suppression
          "pci=noaer"
          "nowatchdog"

          # Security trade-offs
          "mitigations=off"
          "ibt=off"
        ];
      };

      powerManagement.cpuFreqGovernor = "performance";
    };
  };
}
