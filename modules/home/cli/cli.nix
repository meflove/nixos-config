{
  inputs,
  pkgs,
  lib,
  config,
  namespace,
  system,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.home.cli.basicStuff;
in {
  options.${namespace}.home.cli.basicStuff = {
    enable =
      lib.mkEnableOption "enable basic CLI tools and configurations"
      // {
        default = config.${namespace}.home.cli.fishShell.enable;
      };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dust
      duf
      progress
      viddy
      kalker
      python313Packages.downloader-cli
      blobdrop
    ];

    services.clipse = {
      enable = true;

      historySize = 1000;
      imageDisplay.type = "sixel";
    };

    systemd.user.services.clipse = lib.mkForce {};

    programs.eza = {
      enable = true;

      git = true;
      icons = "always";
      colors = "always";

      extraOptions = [
        "-a"
        "-1"
      ];
    };

    programs = {
      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      starship = {
        enable = true;
        enableFishIntegration = true;
      };

      yt-dlp = {
        enable = true;
        package = inputs.chaotic.packages.${system}.yt-dlp_git;

        settings = {
          embed-thumbnail = true;
          embed-metadata = true;
          embed-subs = true;
          sub-langs = "all";
          downloader = lib.getExe pkgs.aria2;
          downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
        };
      };
    };
  };
}
