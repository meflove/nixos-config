{ ... }:
{
  security = {
    sudo.enable = false;

    sudo-rs = {
      enable = true;

      execWheelOnly = true;
      wheelNeedsPassword = true;
      extraRules = [
        {
          commands = [
            {
              command = "/run/current-system/sw/bin/nixos-rebuild";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }
      ];
    };
  };
}
