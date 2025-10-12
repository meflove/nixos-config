{...}: {
  programs.otter-launcher = {
    enable = true;
  };

  # source config due to problems with unicode in nix to toml conversion
  xdg.configFile."otter-launcher/config.toml".source = ./config.toml;
}
