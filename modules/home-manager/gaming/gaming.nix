{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protonup
  ];

  home.sessionVariables = {
    STEAM_COMPAT_TOOLS_PATH = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  programs.mangohud = {
    enable = true;

    settings = {
      winesync = true;

      full = true;
    };
  };
}
