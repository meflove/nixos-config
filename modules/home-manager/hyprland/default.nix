# /home/meflove/git/nixos-config/modules/home-manager/hyprland/default.nix
{ pkgs, lib, ... }:
let
  rules = import ./rules.nix;
  env = import ./env.nix;
  execs = import ./execs.nix;
  binds = import ./binds.nix;
  envConfig = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "env = ${name},${value}") env);
  execOnceConfig = lib.concatStringsSep "\n" (map (command: "exec-once = ${command}") execs);
in
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
  ];
  
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    settings = (import ./settings.nix { inherit pkgs; }) // {
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
      ${execOnceConfig}
    '';
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

}
