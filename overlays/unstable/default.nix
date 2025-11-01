{inputs, ...}: _final: pkgs: {
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config = {allowUnfree = true;};
  };
}
