{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      lib,
      ...
    }: let
      yazi-plugins = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "main";
        hash = "sha256-pAkBlodci4Yf+CTjhGuNtgLOTMNquty7xP0/HSeoLzE=";
      };
    in {
      hm = {
        programs.yazi = {
          enable = true;
          enableFishIntegration = true;
          package = inputs.yazi.packages.${lib.hostPlatform}.default.override {
            _7zz = pkgs._7zz-rar;
          };

          shellWrapperName = "y";

          settings = {
            mgr = {
              show_hidden = true;
            };
            preview = {
              max_width = 1000;
              max_height = 1000;
            };
          };

          plugins = {
            chmod = "${yazi-plugins}/chmod.yazi";
            full-border = "${yazi-plugins}/full-border.yazi";
            toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
            starship = pkgs.fetchFromGitHub {
              owner = "Rolv-Apneseth";
              repo = "starship.yazi";
              rev = "main";
              sha256 = "sha256-CPRVJVunBLwFLCoj+XfoIIwrrwHxqoElbskCXZgFraw=";
            };
          };

          initLua = ''
            require("full-border"):setup()
            require("starship"):setup()
          '';

          keymap = {
            mgr.prepend_keymap = [
              {
                on = "T";
                run = "plugin toggle-pane max-preview";
                desc = "Maximize or restore the preview pane";
              }
              {
                on = [
                  "c"
                  "m"
                ];
                run = "plugin chmod";
                desc = "Chmod on selected files";
              }
            ];
          };
        };
      };
    };
  };
}
