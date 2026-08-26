{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      inputs,
      lib,
      config,
      ...
    }: let
      cursorSmear =
        pkgs.fetchurl
        {
          url = "https://raw.githubusercontent.com/KroneCorylus/ghostty-shader-playground/refs/heads/main/public/shaders/cursor_smear.glsl";
          sha256 = "sha256-+5jUoSYIv3YJ/1ge7Bj49+ZVtz890cYvUng33UgGakM=";
        };
    in {
      hm = {
        programs.ghostty = {
          enable = true;
          package = inputs.ghostty.packages.${lib.hostPlatform}.ghostty;
          systemd.enable = true;
          enableFishIntegration = true;
          installBatSyntax = true;
          installVimSyntax = true;

          settings = {
            theme = "stylix";
            custom-shader = [
              "${cursorSmear}"
            ];

            # adjust-cell-height = "15%";

            window-theme = "ghostty";

            gtk-titlebar = false;
            app-notifications = true;
            confirm-close-surface = false;

            cursor-style = "block";
            cursor-style-blink = false;
            mouse-scroll-multiplier = "0.5";
            shell-integration-features = "no-cursor";

            link-url = true;

            window-padding-x = 9;
            window-padding-y = 9;

            command = lib.getExe config.programs.fish.package;
          };
        };
      };
    };
  };
}
