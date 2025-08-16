{ pkgs, config, ... }: {
  config = {
    programs.gamemode = {
      enable = true;
      settings.general.inhibit_screensaver = 0;
    }; # for performance mode

    programs.steam = {
      enable = true; # install steam

      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      lutris # install lutris launcher

      wineWowPackages.staging
      winetricks
      wineWowPackages.waylandFull

      equibop

      veloren
      mindustry-wayland
      shattered-pixel-dungeon
    ];
  };
}
