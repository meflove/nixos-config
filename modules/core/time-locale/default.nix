{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      time.timeZone = "Asia/Barnaul";
      services = {
        ntpd-rs = {
          enable = true;
        };
      };

      i18n = {
        extraLocales = [
          "en_US.UTF-8/UTF-8"
          "ru_RU.UTF-8/UTF-8"
        ];

        defaultLocale = "en_US.UTF-8";

        extraLocaleSettings = {
          LC_MESSAGES = "en_US.UTF-8";
          LC_TIME = "en_GB.UTF-8";
        };
      };
    };
  };
}
