{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      hardware.usbStorage.manageShutdown = true;
    };
  };
}
