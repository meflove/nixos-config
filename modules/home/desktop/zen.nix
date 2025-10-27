{
  inputs,
  lib,
  config,
  namespace,
  system,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.zenBrowser;
in {
  options.${namespace}.home.desktop.zenBrowser = {
    enable =
      lib.mkEnableOption "enable Zen Browser with custom configuration"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    home.packages = with inputs; [
      (zen-browser.packages.${system}.default.override {
        extraPrefsFiles = [
          (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
            sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
          })
        ];
      })
    ];
  };
}
