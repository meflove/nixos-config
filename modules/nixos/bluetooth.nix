{ config, pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true; # Включает поддержку Bluetooth [20]
    powerOnBoot = true; # Включает Bluetooth-контроллер при загрузке [20]

    # Настройки для Bluetooth-гарнитур с PulseAudio [20]
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket"; # Включает A2DP Sink [20]
      };
    };
    # Включение экспериментальных функций для отображения заряда батареи (по желанию) [20]
    enableExperimental = true;
  };

  # Включение PulseAudio для работы с Bluetooth-аудио [20]
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true; # wireplumber - это менеджер сессий для PipeWire
  };

  # Включение дополнительных Bluetooth-кодеков (AAC, APTX, LDAC) [20]
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; # pulseaudioFull включает дополнительные кодеки
  };
}
