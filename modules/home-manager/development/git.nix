{ pkgs, ... }:
{

  home.packages = with pkgs; [ diffnav ];

  programs.git = {
    enable = true;
    userName = "meflove";
    userEmail = "meflov3r@icloud.com";

    extraConfig = {
      init = {
        defaultBranch = "main";
      };

      pager.diff = "diffnav";

      push = {
        autoSetupRemote = true;
        default = "current";
      };
    };
  };
}
