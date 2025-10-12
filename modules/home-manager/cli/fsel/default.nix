{...}: {
  imports = [./hm-module.nix];

  programs.fsel = {
    enable = false;

    settings = {
      terminal_launcher = "ghostty -e";
    };
  };
}
