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

              signing = {
                key = config.hm.programs.git.settings.user.signingkey;
              };

              ui = {
                editor = lib.getExe pkgs.nixCats;
                show-cryptographic-signatures = true;
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
                clone = ["git" "clone"];
                fetch = ["git" "fetch"];
                push = ["git" "push"];
                logall = ["log" "-r" "\"all()\""];
              };
            };
          };
        };
      };
    };
  };
}
