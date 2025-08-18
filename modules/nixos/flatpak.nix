{ ... }: {
  services.flatpak = {
    enable = true;

    update.auto.enable = false;

    packages = [ "org.vinegarhq.Sober" ];
  };
}
