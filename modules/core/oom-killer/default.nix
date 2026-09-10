{
  flake = _: {
    nixosModules.${baseNameOf ./.} = _: {
      services.earlyoom = {
        enable = true;
        enableNotifications = true;

        freeMemThreshold = 10;
        freeSwapThreshold = 15;

        extraArgs = [
          "--avoid"
          "^(systemd|niri|dbus-broker|dbus-daemon|sshd|fish|nushell|zellij|ghostty|kitty|nix|nixos|nix-daemon|gpg-agent)$"
          "--prefer"
          "^(chrome|chromium|firefox|Web Content|Isolated Web Co|steamwebhelper)$"
        ];
      };
    };
  };
}
