{ pkgs, ... }: {

  time.timeZone = "Asia/Barnaul";

  i18n = {
    supportedLocales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];

    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
  };
  environment.systemPackages = with pkgs; [
    nuspell
    hyphen
    hunspell
    hunspellDicts.en_US
    hunspellDicts.ru_RU
  ];
}
