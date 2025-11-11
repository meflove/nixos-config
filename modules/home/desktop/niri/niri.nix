{
  pkgs,
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.niri;

  settings = import ./settings.nix {inherit pkgs lib;};
in {
  options.${namespace}.home.desktop.niri = {
    enable =
      lib.mkEnableOption ''
        enable niri
      ''
      // {default = true;};

    autologin.enable = lib.mkEnableOption ''Enable automatic login for a specified user. '' // {default = false;};
  };

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;

      inherit settings;
    };
  };
}
