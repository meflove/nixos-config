{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      services.gnome.gnome-keyring.enable = true;
      security = {
        sudo.enable = false;

        sudo-rs = {
          enable = true;

          execWheelOnly = true;
          wheelNeedsPassword = true;
        };
      };
    };
  };
}
