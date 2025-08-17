{ pkgs, lib, inputs, ... }:
let
  rules = import ./rules.nix;
  env = import ./env.nix;
  execs = import ./execs.nix;
  binds = import ./binds.nix;
  envConfig = lib.concatStringsSep "\n"
    (lib.mapAttrsToList (name: value: "env = ${name},${value}") env);
  execOnceConfig =
    lib.concatStringsSep "\n" (map (command: "exec-once = ${command}") execs);
in {
  imports = [ ./hypridle.nix ./hyprlock.nix ./hyprpanel.nix ];

  home.packages = with pkgs; [ grim grimblast slurp hyprpicker libnotify ];

  home.pointerCursor = {
    gtk.enable = true;
    hyprcursor.enable = true;
    x11 = {
      enable = true;
      defaultCursor = "Bibata-Modern-Classic";
    };

    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;

    settings = (import ./settings.nix { inherit pkgs; }) // {
      bind = binds;
      bindm =
        [ "Super, mouse:272, movewindow" "Super, mouse:273, resizewindow" ];

      windowrule = rules.windowRules;
      layerrule = rules.layerRules;
    };

    extraConfig = ''
      ${envConfig}
      ${execOnceConfig}
    '';

    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
    ];
  };

  xdg = {
    enable = true;
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };
  };
}
