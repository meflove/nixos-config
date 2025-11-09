{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.ssh;
in {
  options.${namespace}.nixos.core.ssh = {
    enable =
      lib.mkEnableOption ''
        Enable OpenSSH server for remote access and management.

        This configures SSH server with security-focused defaults:
        - Password authentication enabled (convenient for local networks)
        - Root login disabled for security
        - Public key authentication enabled
        - Keyboard-interactive authentication enabled

        Consider using SSH keys instead of passwords for remote access.
      ''
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    # Assertions to validate SSH configuration
    assertions = [
      {
        assertion = config.${namespace}.nixos.core.firewall.enable || builtins.hasAttr "allowedTCPPorts" config.networking.firewall && builtins.elem 22 config.networking.firewall.allowedTCPPorts;
        message = "SSH requires port 22 to be open in the firewall. Enable firewall module or add port 22 to allowedTCPPorts.";
      }
    ];

    services.openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };

      extraConfig = ''
        PubkeyAuthentication yes
        KbdInteractiveAuthentication yes
      '';
    };
  };
}
