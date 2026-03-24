{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
      hm = {
        programs.nixcord = {
          enable = true; # Enable Nixcord (It also installs Discord)
          discord.equicord.enable = true;
          discord.vencord.enable = false;
          vesktop = {
            enable = false; # Vesktop
            package = pkgs.vesktop;
          };

          quickCss = ''
            body {
              --font: 'JetBrainsMono Nerd Font Mono';
              --code-font: 'JetBrainsMono Nerd Font Mono';
              font-weight: 400;
            }
          '';

          config = {
            autoUpdate = true;

            useQuickCss = true; # use out quickCSS
            themeLinks = [
              # or use an online theme
              "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-catppuccin-mocha.theme.css"
            ];
            enabledThemes = ["catppuccin-mocha.theme.css"];

            frameless = true; # Set some Vencord options
            plugins = {
              alwaysAnimate.enable = true;
              crashHandler.enable = true;
              experiments.enable = true;
              fakeNitro.enable = true;
              fakeProfileThemes.enable = true;
              fixImagesQuality.enable = true;
              gameActivityToggle.enable = true;
              PinDMs.enable = true;
              readAllNotificationsButton.enable = true;
              roleColorEverywhere.enable = true;
              showAllMessageButtons.enable = true;
              showHiddenChannels.enable = true;
              translate.enable = true;
              webKeybinds.enable = true;
              webScreenShareFixes.enable = true;
            };
          };
        };
      };
    };
  };
}
