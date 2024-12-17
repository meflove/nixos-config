{ config, pkgs, ... }:
{
  # Включение поддержки графики
  hardware.graphics.enable = true;

  # Загрузка драйвера nvidia для Xorg и Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting обязателен [19]
    modesetting.enable = true;

    # Для RTX 3060 (архитектура Turing или новее) рекомендуется использовать открытые драйверы [12, 19]
    open = true;

    # Управление питанием NVIDIA (экспериментально, может вызывать проблемы со сном/приостановкой) [19]
    # powerManagement.enable = true; # Отключено по умолчанию из-за потенциальных проблем

    # Если это ноутбук с гибридной графикой (Optimus PRIME), необходимо настроить PRIME [12]
    # Для ПК это обычно не требуется, но если есть интегрированная графика, может быть полезно.
    # hardware.nvidia.prime = {
    #   offload.enable = true; # Включение offload для запуска приложений на dGPU [12]
    #   intelBusId = "PCI:0:2:0"; # Замените на Bus ID вашей интегрированной Intel GPU
    #   nvidiaBusId = "PCI:1:0:0"; # Замените на Bus ID вашей NVIDIA GPU (lspci -d ::03xx) [12]
    # };
  };

  # Разрешение несвободного ПО, необходимого для драйверов NVIDIA [12]
  nixpkgs.config.allowUnfree = true;
}
