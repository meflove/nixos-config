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
  # nixpkgs-patched = inputs.nixpkgs-patcher.lib.patchNixpkgs {
  #   inherit inputs;
  #   inherit (pkgs) system;
  # };
  # patched = import nixpkgs-patched overlaysSettings;
}
