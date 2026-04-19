{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: let
      outputPreset = import ./output_preset.nix;
      inputPreset = import ./input_preset.nix;
    in {
      programs = {
        dconf.enable = true;
      };
      hm = {
        services.easyeffects = {
          enable = true;
          # TODO: Remove override when new version with fix is released.
          package = pkgs.easyeffects.overrideAttrs (
            _: {
              version = "8.2.0-dev";
              src = pkgs.fetchFromGitHub {
                owner = "wwmm";
                repo = "easyeffects";
                rev = "4049f3b570a16a1b5ef0d536d66a4a81a247f6dd";
                hash = "sha256-N/q4BMeSbyLb6vPrZHgS5tchhAaEO7+/aRCoBllZV+M=";
              };
            }
          );

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
