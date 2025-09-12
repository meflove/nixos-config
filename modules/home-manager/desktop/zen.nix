{ inputs, pkgs, ... }:
let
  system = "x86_64-linux";
in
{
  home.packages = with inputs; [
    (zen-browser.packages."${system}".default.override {
      extraPrefsFiles = [
        (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
          sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
        })
      ];
    })
  ];
}
