{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      lib,
      ...
    }: {
      environment = {
        systemPackages = with pkgs; [
          wl-clipboard
          gtk3
          gtk4
          jq
        ];
      };

      programs.dms-shell = {
        enable = true;
        package = inputs.dms.packages.${lib.hostPlatform}.default;
        quickshell.package = inputs.quickshell.packages.${lib.hostPlatform}.quickshell;

        systemd = {
          enable = true; # Systemd service for auto-start
          restartIfChanged = true;
        };

        enableVPN = false;
        enableDynamicTheming = false;

        enableAudioWavelength = true; # Audio visualizer (cava)
        enableCalendarEvents = true; # Calendar integration (khal)
      };
    };
  };
}
