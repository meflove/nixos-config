{ pkgs, config, ... }:

let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  session = "${config.programs.hyprland.package}/bin/Hyprland 2>&1";
  username = "angeldust";
in
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
        user = "greeter";
      };
    };
  };
}
