_: {
  magic-enter-cmd = {
    body =
      # fish
      ''
        set -l cmd ll
        set -l git_root (git rev-parse --show-toplevel 2>/dev/null)

        if test -n "$git_root"
          # Check if .jj exists in git repo root
          if test -d "$git_root/.jj"
            set -l jj_status (jj status --no-pager 2>/dev/null | string trim)

            if test -n "$jj_status"
              set cmd "ll && jj status --no-pager"
            end
          else
            # Use git status
            set -l git_status (git status --porcelain -s)

            if test -n "$git_status"
              set cmd "ll && git status"
            end
          end
        end
        echo $cmd
      '';
  };
  magic-enter = {
    body =
      # fish
      ''
        set -l cmd (commandline)
        if test -z "$cmd"
          commandline -r (magic-enter-cmd)
          commandline -f suppress-autosuggestion
        end
        commandline -f execute

      '';
  };
  magic-enter-bindings = {
    body =
      # fish
      ''
        bind \r magic-enter
        if functions -q fish_vi_key_bindings
            bind -M insert \r magic-enter
            bind -M default \r magic-enter
        end
      '';
  };
}
