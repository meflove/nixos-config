{
  pkgs,
  inputs,
  ...
}: {
  programs.gamemode = {
    enable = true;
    settings.general.inhibit_screensaver = 0;
  }; # for performance mode

  programs.steam = {
    enable = true; # install steam

    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; let
    gamePkgs = inputs.nix-gaming.packages.${pkgs.hostPlatform.system};
  in [
    inputs.freesmlauncher.packages.${pkgs.system}.freesmlauncher
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    lutris # install lutris launcher
    winetricks
    vkd3d-proton
    dxvk

    # veloren
    # mindustry-wayland
    # shattered-pixel-dungeon
    # (gamePkgs.osu-stable.override {
    #   useGameMode = false;
    # })
    # osu-lazer-bin

    logiops
  ];

  services.solaar = {
    enable = true; # Enable the service
    package = pkgs.solaar; # The package to use

    window = "only"; # Show the window on startup (show, *hide*, only [window only])
    batteryIcons = "regular"; # Which battery icons to use (*regular*, symbolic, solaar)
    extraArgs = ""; # Extra arguments to pass to solaar on startup
  };

  hardware = {
    new-lg4ff.enable = true;
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
