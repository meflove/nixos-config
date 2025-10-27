{
  pkgs,
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.autologin;

  tuigreet = lib.getExe pkgs.tuigreet;
  session = "${lib.getExe config.programs.hyprland.package} 2>&1";
  username = "angeldust";
in {
  options.${namespace}.nixos.core.autologin = {
    enable =
      lib.mkEnableOption "Enable automatic login for a specified user."
      // {
        default = true;
      };

    user = lib.mkOption {
      type = lib.types.str;
      default = "${username}";
      description = "The user to automatically log in.";
    };
  };
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          inherit (cfg) user;
          command = "${session}";
        };
        default_session = {
          command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
          user = "greeter";
        };
      };
    };
  };
}
