{config, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = true;

    nvidiaSettings = false;
  };
}
