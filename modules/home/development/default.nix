{...}: {
  imports = [
    ./gemini/gemini.nix
    ./claude/claude.nix
    ./direnv.nix
    ./git.nix
    ./nvim/nvim.nix
    ./zed.nix
    ./ssh-and-gpg.nix
  ];
}
