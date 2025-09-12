{ ... }:
{
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
}
