{
  pkgs,
  config,
  lib,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.autologin;

  tuigreet = lib.getExe pkgs.tuigreet;
  session = "${lib.getExe config.programs.hyprland.package}";
  username = "angeldust";
in {
  options.${namespace}.nixos.core.autologin = {
    enable =
      lib.mkEnableOption ''
        Enable automatic login for a specified user using greetd with tuigreet.

        WARNING: This bypasses password authentication and reduces system security.
        Only recommended for single-user systems or secure environments.

        Configures greetd display manager with:
        - Automatic session start for specified user
        - Fallback to tuigreet greeter with session selection
        - Hyprland as default desktop environment
      ''
      // {
        default = (inputs.self.homeConfigurations."angeldust@nixos-pc".config.${namespace}.home.desktop.hyprland.autologin.enable || inputs.self.homeConfigurations."angeldust@nixos-pc".config.${namespace}.home.desktop.niri.autologin.enable) || false;
      };

    user = lib.mkOption {
      type = lib.types.str;
      default = "${username}";
      description = ''
        The username to automatically log in as.

        The user must exist in the system and have a valid shell.
        Recommended to use this only for your primary user account.
      '';
    };
  };
  config = mkIf cfg.enable {
    # Assertions to validate configuration
    assertions = [
      {
        assertion = config.users.users ? ${cfg.user};
        message = "User '${cfg.user}' must exist for autologin to work. Please create the user or specify a different username.";
      }
      {
        assertion = !(inputs.self.homeConfigurations."angeldust@nixos-pc".config.${namespace}.home.desktop.hyprland.autologin.enable && inputs.self.homeConfigurations."angeldust@nixos-pc".config.${namespace}.home.desktop.niri.autologin.enable);
        message = "Only one display server (Hyprland or Niri) can be enabled for autologin to function properly.";
      }
    ];

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
