{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.hardware.bluetooth;
in {
  options.${namespace}.nixos.hardware.bluetooth = {
    enable =
      lib.mkEnableOption "enable Bluetooth support"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    hardware = {
      enableRedistributableFirmware = true;
      enableAllHardware = true;

      bluetooth = {
        enable = true; # Включает поддержку Bluetooth [20]
        powerOnBoot = true; # Включает Bluetooth-контроллер при загрузке [20]

        # Настройки для Bluetooth-гарнитур с PulseAudio [20]
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket"; # Включает A2DP Sink [20]
            Experimental = true;
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      bluetui
      bluez-experimental
    ];
  };
}
