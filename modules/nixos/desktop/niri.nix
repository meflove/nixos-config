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

    systemPackages = with pkgs; [xdg-utils];
  };
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    useNautilus = false;
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };
}
