{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      lib,
      pkgs,
      ...
    }: {
      hm = {
        home.packages = lib.attrValues {
          inherit
            (pkgs)
            diffnav # Diff viewer for git
            delta # diff viewer
            ;
        };
        programs = {
          jjui.enable = true;
          delta = {
            enable = true;
          };
          jujutsu = {
            enable = true;
            package = pkgs.jujutsu_git;

            settings = {
              inherit (config.hm.programs.git.settings) user;
              ui = {
                editor = lib.getExe pkgs.nixCats;
              };
              git = {
                fetch = "origin";
                push = "origin";
              };
              remotes.origin.auto-track-bookmarks = "main";

              "--scope" = [
                {
                  "--when" = {
                    commands = ["diff" "show"];
                  };
                  ui = {
                    pager = "diffnav";
                    diff-formatter = ":git";
                  };
                }
              ];
              aliases = {
                init = ["git" "init" "--colocate"];
                cma = ["commit" "-m"];

                ps = let
                  grep = lib.getExe pkgs.gnugrep;
                  sed = lib.getExe pkgs.gnused;
                in [
                  "util"
                  "exec"
                  "--"
                  "bash"
                  "-c"
                  ''
                    set -e

                    # Check if current commit has both description and changes
                    has_description=$(jj log -r @ --no-graph --color never -T 'description' | ${grep} -q . && echo "yes" || echo "no")
                    # Use 'empty' template keyword to check if commit has changes
                    has_changes=$(jj log -r @ --no-graph --color never -T 'empty' | ${grep} -q "false" && echo "yes" || echo "no")

                    if [ "$has_description" = "yes" ] && [ "$has_changes" = "yes" ]; then
                        echo "Current commit has description and changes, creating new commit..."
                        jj new
                    fi

                    # Get the bookmark from the parent commit directly
                    bookmark=$(jj log -r 'ancestors(@) & bookmarks()' -n 1 --no-graph --color never -T 'bookmarks' | ${sed} 's/\\*$//' | tr -d ' ' | xargs)

                    if [ -z "$bookmark" ]; then
                        echo "No bookmark found on parent commit"
                        exit 1
                    fi

                    echo "Moving bookmark '$bookmark' to parent commit and pushing..."
                    jj bookmark set "$bookmark" -r @-
                    jj git fetch
                    jj git push --bookmark "$bookmark"
                  ''
                ];
              };
            };
          };
        };
      };
    };
  };
}
