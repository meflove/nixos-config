{
  __magic-enter = {
    body = ''
      function magic-enter-cmd --description "Issue git status or ls on hitting enter in a dir"
        set -l cmd ll
        set -l is_git_repository (fish -c "git rev-parse --is-inside-work-tree 2>/dev/null" | grep true)
        set -l in_root_folder (fish -c "git rev-parse --show-toplevel 2>/dev/null" | grep (pwd))
        set -l repo_has_changes (fish -c "git status -s --ignore-submodules=dirty 2>/dev/null")

        if test -n "$is_git_repository"
          if test -n "$in_root_folder"
            if test -n "$repo_has_changes"
              set cmd "ll && g status"
            end
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
