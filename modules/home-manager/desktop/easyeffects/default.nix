{ ... }:
let
  outputPreset = import ./output_preset.nix;
  inputPreset = import ./input_preset.nix;
in
{
  services.easyeffects = {
    enable = true;

    extraPresets = {
      music = outputPreset;
      micro = inputPreset;
    };
  };

  xdg.configFile."easyeffects/irs/accudio48khz.irs".source = ./accudio48khz.irs;
}
