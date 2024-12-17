{ config, pkgs, ... }:
{
  networking.wireless.enable = true; # Включает беспроводную сеть [1, 21]

  # Использование NetworkManager для управления беспроводными сетями (рекомендуется для десктопов) [21]
  networking.networkmanager.enable = true;

  # Пример декларативного определения Wi-Fi сетей (используйте осторожно из-за хранения паролей в открытом виде) [21]
  networking.wireless.networks = {
    "Keenetic-60" = {
      psk = "home1234";
    };
  };

  # Если вы хотите использовать wpa_supplicant напрямую без NetworkManager,
  # можно указать pskRaw, сгенерированный wpa_passphrase.[21]
  # networking.wireless.networks = {
  #   echelon = {
  #     pskRaw = "dca6d6ed41f4ab5a984c9f55f6f66d4efdc720ebf66959910f4329bb391c5435";
  #   };
  # };
}
