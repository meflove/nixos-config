{
  inputs,
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.home.${namespace}.cli.basicStuff;
in {
  options.home.${namespace}.cli.basicStuff = {
    enable =
      lib.mkEnableOption "enable basic CLI tools and configurations"
      // {
        default = config.home.${namespace}.cli.fishShell.enable;
      };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # === File System & Disk Utilities ===
      # Modern alternatives to standard tools
      dust # Disk usage visualization (du alternative)
      duf # Disk usage/free tool with colors (df alternative)

      # === System Monitoring & Progress ===
      progress # Coreutils progress viewer
      viddy # Modern watch command with TUI

      # === CLI Tools & Utilities ===
      kalker # Calculator with support for units and functions
      blobdrop # TUI for drag-and-drop file transfers to browser/desktop apps

      # === Download & Media ===
      python313Packages.downloader-cli # CLI downloader with progress bars
    ];

    services.clipse = {
      enable = true;

      historySize = 10000;
      imageDisplay.type = "sixel";
    };

    systemd.user.services.clipse = lib.mkForce {};

    programs = {
      eza = {
        enable = true;

        git = true;
        icons = "always";
        colors = "always";

        extraOptions = [
          "-a"
          "-1"
        ];
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      starship = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          os = {
            disabled = false;
            format = "$symbol  ";
            symbols.NixOS = "";
          };
        };
      };

      yt-dlp = {
        enable = true;
        package = inputs.chaotic.packages.${pkgs.stdenv.hostPlatform.system}.yt-dlp_git;

        settings = {
          embed-thumbnail = true;
          embed-metadata = true;
          embed-subs = true;
          sub-langs = "all";
          downloader = lib.getExe pkgs.aria2;
          downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
        };
      };

      nix-index = {
        enable = true;
        enableFishIntegration = true;
        package = inputs.nix-index.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
    };
  };
}
