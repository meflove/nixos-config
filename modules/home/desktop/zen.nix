{
  pkgs,
  inputs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.desktop.zenBrowser;
in {
  options.home.${namespace}.desktop.zenBrowser = {
    enable =
      lib.mkEnableOption "enable Zen Browser with custom configuration"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta;

      nativeMessagingHosts = [pkgs.firefoxpwa];
    };
  };
}
