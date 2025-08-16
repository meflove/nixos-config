{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ diffnav ];

  programs.git = {
    enable = true;
    config = {
      init = { defaultBranch = "main"; };
      pager.diff = "diffnav";
    };
  };
}
