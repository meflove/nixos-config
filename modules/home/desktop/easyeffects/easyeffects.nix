{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.easyeffects;

  outputPreset = import ./output_preset.nix;
  inputPreset = import ./input_preset.nix;
in {
  options.${namespace}.home.desktop.easyeffects = {
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

    xdg.configFile."easyeffects/irs/accudio48khz.irs".source = ./accudio48khz.irs;
  };
}
