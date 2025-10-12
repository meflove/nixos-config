{
  pkgs,
  lib,
  inputs,
  ...
}: let
  rules = import ./rules.nix;
  env = import ./env.nix;
  binds = import ./binds.nix {inherit inputs;};
  envConfig = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value: "env = ${name},${value}") env
  );
in {
  imports = [
    ./hyprlock.nix
    ./hyprpanel.nix
  ];

  home = {
    packages = with pkgs; [
      grim
      grimblast
      slurp
      hyprpicker
      libnotify
      tesseract
      swww
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    systemd = {
      enable = true;

      variables = [
        "--all"
        "DISPLAY"
        "WAYLAND_DISPLAY"
        "XDG_CURRENT_DESKTOP"
      ];

      enableXdgAutostart = true;
    };

    xwayland.enable = true;

    settings =
      (import ./settings.nix {inherit pkgs;})
      // {
        bind = binds;
        bindm = [
          "Super, mouse:272, movewindow"
          "Super, mouse:273, resizewindow"
        ];

        windowrule = rules.windowRules;
        layerrule = rules.layerRules;
      };

    extraConfig = ''
      ${envConfig}

      exec-once = clipse -listen
      exec-once = easyeffects --gapplication-service &
      exec-once = hyprpanel &> /dev/null
      exec-once = hyprlock

      exec-once = [workspace 1 silent] AyuGram
      exec-once = [workspace 2 silent] zen
    '';
  };
}
