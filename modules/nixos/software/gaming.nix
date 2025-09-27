{ pkgs, inputs, ... }:
{
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

      # wineWowPackages.staging
      inputs.nix-gaming.packages.${pkgs.system}.wine-tkg-ntsync
      winetricks
      wineWowPackages.waylandFull
      vkd3d-proton
      dxvk

      veloren
      mindustry-wayland
      shattered-pixel-dungeon
      inputs.freesmlauncher.packages.${pkgs.system}.freesmlauncher
    ];
  };
}
