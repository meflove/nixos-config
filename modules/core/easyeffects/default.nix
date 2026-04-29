{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: let
      outputPreset = import ./output_preset.nix;
      inputPreset = import ./input_preset.nix;
    in {
      programs = {
        dconf.enable = true;
      };
      hm = {
        services.easyeffects = {
          enable = true;

          extraPresets = {
            music = outputPreset;
            micro = inputPreset;
          };
        };

        home = {
          file = {
            ".local/share/easyeffects/irs/accudio48khz.irs".source = ./accudio48khz.irs;
          };
        };
      };
    };
  };
}
