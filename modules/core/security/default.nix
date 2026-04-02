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
      environment = {
        sessionVariables = {
          SUDO_PROMPT = "{$(tput setaf 1 bold)Password:$(tput sgr0)} ";
        };
      };
    };
  };
}
