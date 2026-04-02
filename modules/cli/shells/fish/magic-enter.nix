{
  config,
  lib,
}: let
  git = lib.getExe config.hm.programs.git.package;
  jj = lib.getExe config.hm.programs.jujutsu.package;
in {
  __magic-enter = {
    body = ''
      function magic-enter-cmd --description "Issue git status or ls on hitting enter in a dir"
        set -l cmd ll
        set -l git_root (${git} rev-parse --show-toplevel 2>/dev/null)

        if test -n "$git_root"
          # Check if .jj exists in git repo root
          if test -d "$git_root/.jj"
            set -l jj_status (${jj} status --no-pager 2>/dev/null | string trim)

            if test -n "$jj_status"
              set cmd "ll && ${jj} status --no-pager"
            end
          else
            # Use git status
            set -l git_status (${git} status --porcelain -s)

            if test -n "$git_status"
              set cmd "ll && ${git} status"
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
