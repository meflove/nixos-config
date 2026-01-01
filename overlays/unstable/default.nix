{inputs, ...}: _final: pkgs: rec {
  overlaysSettings = {
    inherit (pkgs) system;

    config = {
      allowUnfree = true;
      # allowBroken = true;
      cudaSupport = true;
    };
  };

  master = import inputs.nixpkgs-master overlaysSettings;
}
