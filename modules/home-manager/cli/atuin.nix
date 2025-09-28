{ ... }:
{
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;

      timezone = "+7";
      dialect = "uk";

      enter_accept = true;
      search_mode = "fuzzy";

      style = "full";

      common_subcommands = [
        "git"
        "ip"
        "systemctl"
        "nix"
      ];
      ignored_commands = [
        "c"
      ];
    };
  };
}
