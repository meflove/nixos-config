{
  pkgs,
  inputs,
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.cli.basic-stuff;
in {
  options.${namespace}.nixos.cli.basic-stuff = {
    enable =
      lib.mkEnableOption ''
        enable basic CLI tools and configurations
      ''
      // {default = true;};
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      comma
    ];

    services = {
      locate = {
        enable = true;
        package = pkgs.plocate;
        interval = "hourly";
      };
    };

    programs = {
      nh = {
        enable = true;
        package = inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default;

        flake = "/home/angeldust/.config/nixos-config"; # sets NH_OS_FLAKE variable for you

        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep-since 7d --keep 10";
        };
      };
    };
  };
}
