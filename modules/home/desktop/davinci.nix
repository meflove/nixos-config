{
  pkgs,
  inputs,
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.desktop.davinci;
in {
  options.home.${namespace}.desktop.davinci = {
    enable =
      lib.mkEnableOption ''
        enable Davinci Resolve, a video editing software.
      ''
      // {default = false;};
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.jonhermansen-nur-packages.packages.${pkgs.stdenv.hostPlatform.system}.davinci-resolve-studio
    ];
  };
}
