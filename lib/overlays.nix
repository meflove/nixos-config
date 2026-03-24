{
  inputs,
  nixConfig,
}:
with inputs; [
  niri.overlays.niri
  claude-code.overlays.default
  hyprland.overlays.default
  llm-agents.overlays.default

  (
    _final: p: let
      inherit (p.stdenv.hostPlatform) system;
      branch-config = {inherit system config;};
      config = nixConfig;
    in {
      master = import inputs.nixpkgs-master branch-config;
    }
  )
  (
    _final: prev: {
      xow_dongle-firmware = prev.xow_dongle-firmware.overrideAttrs (_old: {
        installPhase = ''
          install -Dm644 xow_dongle.bin $out/lib/firmware/xone_dongle_02fe.bin
          install -Dm644 xow_dongle_045e_02e6.bin $out/lib/firmware/xone_dongle_02e6.bin
        '';
      });
    }
  )
]
