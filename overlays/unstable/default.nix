{inputs, ...}: _final: pkgs: rec {
  overlaysSettings = {
    inherit (pkgs) system;

    config = {
      allowUnfree = true;
      # allowBroken = true;
      cudaSupport = true;
    };
  };

  unstable = import inputs.nixpkgs-unstable overlaysSettings;
}
