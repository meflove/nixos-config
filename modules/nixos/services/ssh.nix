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

  services.endlessh = {
    enable = true;
    port = 22;
    openFirewall = true;
  };
}
