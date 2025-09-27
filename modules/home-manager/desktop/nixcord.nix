{ ... }:
{
  # ...
  programs.nixcord = {
    enable = true; # Enable Nixcord (It also installs Discord)
    vesktop.enable = true; # Vesktop

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
      enabledThemes = [ "catppuccin-mocha.theme.css" ];

      frameless = true; # Set some Vencord options
      plugins = {
        alwaysAnimate.enable = true;
        crashHandler.enable = true;
        experiments.enable = true;
        fakeNitro.enable = true;
        fakeProfileThemes.enable = true;
        fixImagesQuality.enable = true;
        gameActivityToggle.enable = true;
        pinDMs.enable = true;
        readAllNotificationsButton.enable = true;
        roleColorEverywhere.enable = true;
        showAllMessageButtons.enable = true;
        showHiddenChannels.enable = true;
        translate.enable = true;
        webKeybinds.enable = true;
        webScreenShareFixes.enable = true;
      };
    };

    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };
  # ...
}
