{ pkgs, ... }: {
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;

      enter_accept = true;
      search_mode = "fuzzy";

      style = "full";

      common_subcommands = [ "git" "ip" "systemctl" "nix" ];
    };
  };
}
