{...}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # silent = true;
    config = {
      global = {
        strict_env = true;
        warn_timeout = "1m";
        hide_env_diff = true;
      };
    };
  };
}
