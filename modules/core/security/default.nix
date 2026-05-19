{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      services.gnome.gnome-keyring.enable = true;
      security = {
        sudo.enable = false;

        sudo-rs = {
          enable = true;
          execWheelOnly = true;
          wheelNeedsPassword = true;

          extraRules = let
            swBin = "/run/current-system/sw/bin";
            wrappersBin = "/run/wrappers/bin";
          in [
            {
              groups = ["wheel"];
              commands = [
                # We're using the name of the symlink in the final system image instead of, for
                # example `"${pkgs.systemd}/bin/shutdown"`, because in the final system it is the symlink
                # that will be invoked and sudo matches against the invoked command and not the resolved
                # binary
                {
                  command = "${swBin}/nixos";
                  options = ["NOPASSWD"];
                }
                {
                  command = "${swBin}/shutdown";
                  options = ["NOPASSWD"];
                }
                {
                  command = "${swBin}/reboot";
                  options = ["NOPASSWD"];
                }
                {
                  command = "${swBin}/poweroff";
                  options = ["NOPASSWD"];
                }
                {
                  command = "${wrappersBin}/mount";
                  options = ["NOPASSWD"];
                }
                {
                  command = "${wrappersBin}/umount";
                  options = ["NOPASSWD"];
                }
              ];
            }
          ];
        };
      };
    };
  };
}
