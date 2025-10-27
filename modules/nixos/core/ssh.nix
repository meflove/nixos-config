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
      lib.mkEnableOption "Enable ssh"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
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
