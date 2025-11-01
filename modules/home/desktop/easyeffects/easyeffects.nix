{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.desktop.easyeffects;

  # Fix new syntax for presets
  # jsonFormat = pkgs.formats.json {};
  #
  # basePresetType = lib.types.attrsOf jsonFormat.type;
  #
  # fixedPresetType = lib.types.addCheck basePresetType (
  #   v:
  #     basePresetType.check v
  #     && lib.elem (lib.head (lib.attrNames v)) ["input" "output"]
  # );

  outputPreset = import ./output_preset.nix;
  inputPreset = import ./input_preset.nix;

  outputPresetJson = builtins.toJSON outputPreset;
  inputPresetJson = builtins.toJSON inputPreset;
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

      # extraPresets = {
      #   music = outputPreset;
      #   micro = inputPreset;
      # };
    };

    xdg = {
      configFile = {
        "easyeffects/output/music.json".text = outputPresetJson;
        "easyeffects/input/micro.json".text = inputPresetJson;

        "easyeffects/irs/accudio48khz.irs".source = ./accudio48khz.irs;
      };
    };
  };
}
