{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      hm = {
        programs.pipewire-soundpad.enable = true;
      };
    };
  };
}
