{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.desktop.easyeffects;

  outputPreset = import ./output_preset.nix;
  inputPreset = import ./input_preset.nix;
in {
  options.home.${namespace}.desktop.easyeffects = {
    enable =
      lib.mkEnableOption "enable EasyEffects audio effects processor"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    services.easyeffects = {
      enable = true;

      extraPresets = {
        music = outputPreset;
        micro = inputPreset;
      };
    };

    home = {
      file = {
        ".loca/share/easyeffects/irs/accudio48khz.irs".source = ./accudio48khz.irs;
      };
    };
  };
}
