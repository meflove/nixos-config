{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {config, ...}: {
      nixpkgs.overlays = [
        (_f: p: {
          ccacheWrapper = p.ccacheWrapper.override {
            extraConfig = ''
              export CCACHE_COMPRESS=1
              export CCACHE_DIR="${config.programs.ccache.cacheDir}"
              export CCACHE_UMASK=007
              if [ ! -d "$CCACHE_DIR" ]; then
                echo "====="
                echo "Directory '$CCACHE_DIR' does not exist"
                echo "Please create it with:"
                echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
                echo "  sudo chown root:nixbld '$CCACHE_DIR'"
                echo "====="
                exit 1
              fi
              if [ ! -w "$CCACHE_DIR" ]; then
                echo "====="
                echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
                echo "Please verify its access permissions"
                echo "====="
                exit 1
              fi
            '';
          };
        })
        (_f: p: {
          linuxPackages_cachyos = p.linuxPackages_cachyos.override {stdenv = p.ccacheStdenv;};
          linux_cachyos = p.linux_cachyos.override {stdenv = p.ccacheStdenv;};
          linux_cachyos-gcc = p.linux_cachyos-gcc.override {stdenv = p.ccacheStdenv;};
        })
      ];

      nix.settings.extra-sandbox-paths = [config.programs.ccache.cacheDir];

      programs.ccache = {
        enable = true;
        packageNames = ["linuxPackages_cachyos" "linux_cachyos" "linux_cachyos-gcc"];
      };
    };
  };
}
