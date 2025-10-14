{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    dust
    duf
    progress
    viddy
    kalker
    python313Packages.downloader-cli
    blobdrop
    grc
  ];

  programs.nh = {
    enable = true;
    flake = "/home/angeldust/.config/nixos-config"; # sets NH_OS_FLAKE variable for you
    osFlake = "/home/angeldust/.config/nixos-config";
    homeFlake = "/home/angeldust/.config/nixos-config";
  };

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

  programs.zoxide = {
    enable = true;

    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;

    enableFishIntegration = true;
  };

  programs.atuin = {
    enable = true;

    enableFishIntegration = true;
    settings = {
      auto_sync = false;

      timezone = "+7";
      dialect = "uk";

      enter_accept = true;
      search_mode = "fuzzy";

      style = "full";

      common_subcommands = [
        "git"
        "ip"
        "systemctl"
        "nix"
      ];
      ignored_commands = [
        "c"
      ];
    };
  };
}
