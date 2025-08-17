{ pkgs, inputs, ... }:
{
  # Включение Lanzaboote
  boot.loader.lanzaboote = {
    enable = true;
    # Убедитесь, что пакет Lanzaboote использует правильную систему
    package = inputs.lanzaboote.packages.${pkgs.system}.lanzaboote;
    # Включение UKI (Unified Kernel Image)
    enableUKI = true;
    # Автоматическая регистрация ключей (требует, чтобы UEFI был в Setup Mode) [26]
    # Это не полностью декларативно и требует ручного создания ключей.[26]
    # Для декларативного подхода, ключи должны быть созданы заранее и указаны здесь.
    # autoEnroll = true;

    # Укажите путь к вашим ключам подписи (PK, KEK, DB)
    # boot.loader.lanzaboote.signingKey = "/path/to/your/db.key";
    # boot.loader.lanzaboote.signingCertificate = "/path/to/your/db.crt";

    # Если вы хотите использовать TPM2 для привязки Secure Boot [24]
    tpm2 = {
      enable = true;
      #... дополнительные настройки TPM2
    };
  };

  # Для использования Lanzaboote с systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.efi.canTouchEfiVariables = true; # Необходимо для записи в переменные UEFI [27]

  # Добавление Lanzaboote в системные пакеты
  environment.systemPackages = with pkgs; [
    inputs.lanzaboote.packages.${pkgs.system}.lanzaboote
  ];

  # Предупреждение: Настройка Secure Boot может привести к "брику" системы,
  # если UEFI-драйверы (OptionROMs) не подписаны или ваша политика Secure Boot не позволяет их загрузку.[24]
  # Это особенно актуально для GPU, которые могут иметь OptionROMs, подписанные Microsoft.
}
