{ pkgs, ... }: {
  hardware.enableAllFirmware = true;
  hardware.bluetooth = {
    enable = true; # Включает поддержку Bluetooth [20]
    powerOnBoot = true; # Включает Bluetooth-контроллер при загрузке [20]

    # Настройки для Bluetooth-гарнитур с PulseAudio [20]
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket"; # Включает A2DP Sink [20]
        Experimental = true;
      };
    };
    # Включение экспериментальных функций для отображения заряда батареи (по желанию) [20]
  };

  environment.systemPackages = with pkgs; [ bluetui bluez-experimental ];

}
