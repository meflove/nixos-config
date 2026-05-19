{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      imports = [./hm-module.nix];

      programs.pipewire-soundpad.enable = true;
    };
  };
}
