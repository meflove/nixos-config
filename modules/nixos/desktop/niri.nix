{pkgs, ...}: {
  environment = {
    etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text = ''
      {
        "rules": [
          {
            "pattern": {
              "feature": "procname",
              "matches": "niri"
            },
            "profile": "Limit Free Buffer Pool On Wayland Compositors"
          }
        ],
        "profiles": [
          {
            "name": "Limit Free Buffer Pool On Wayland Compositors",
            "settings": [
              {
                "key": "GLVidHeapReuseRatio",
                "value": 0
              }
            ]
          }
        ]
      }
    '';

    systemPackages = with pkgs; [xdg-utils pkgs.niri-unstable];
  };

  xdg.portal.configPackages = [pkgs.niri-unstable];

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = {};
}
