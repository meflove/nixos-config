{...}: {
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

  users.users."angeldust".openssh.authorizedKeys.keyFiles = [
    ../../../secrets/ssh/authorized_keys
  ];
}
