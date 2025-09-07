{
  __magic-enter = {
    body = ''
      function magic-enter-cmd --description "Issue git status or ls on hitting enter in a dir"
        set -l cmd ll
        set -l is_git_repository (git rev-parse --is-inside-work-tree 2>/dev/null)

        if test -n "$is_git_repository"
          set -l git_status (git status --porcelain -s)

          if test -n "$git_status"
            set cmd "ll && g status"
          end
        end
        echo $cmd
      end

      function magic-enter
        set -l cmd (commandline)
        if test -z "$cmd"
          commandline -r (magic-enter-cmd)
          commandline -f suppress-autosuggestion
        end
        commandline -f execute
      end

      bind \r magic-enter
    '';
  };
}
