{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      config,
      inputs,
      ...
    }: {
      hm = {
        programs.nixcord = {
          enable = true; # Enable Nixcord (It also installs Discord)
          discord = {
            enable = false;
            equicord.enable = false;
            vencord.enable = false;
          };
          vesktop.enable = false; # Vesktop
          equibop = {
            enable = true; # Equibot
            # package = pkgs.master.equibop;
          };

          quickCss = ''
            body {
              --font: '${config.stylix.fonts.monospace.name}';
              --code-font: '${config.stylix.fonts.monospace.name}';
              font-weight: 400;
            }
          '';

          config = {
            autoUpdate = false;

            useQuickCss = true; # use out quickCSS
            themes = {
              "system24-rose-pine-moon" = builtins.readFile "${inputs.system24-theme}/theme/flavors/system24-rose-pine-moon.theme.css";
            }; # themeLinks not working, idk why :)
            enabledThemes = [
              "system24-rose-pine-moon.css"
            ];

            frameless = true; # Set some Vencord options
            plugins = {
              volumeBooster = {
                enable = true;
                multiplier = 2.0;
              };
              fakeNitro = {
                enable = true;
                enableStickerBypass = true;
                enableStreamQualityBypass = true;
                enableEmojiBypass = true;
                transformEmojis = true;
                transformStickers = true;
                transformCompoundSentence = true;
                emojiSize = 48.0;
                stickerSize = 160.0;
                useEmojiHyperLinks = true;
                hyperLinkText = "{{NAME}}";
                disableEmbedPermissionCheck = true;
              };
              pinDms = {
                enable = true;
                userBasedCategoryList = {
                  "1037346438331514952" = [
                    {
                      id = "ht7ewht5tn6";
                      name = "уебаны";
                      color = 15277667;
                      collapsed = false;
                      channels = [
                        "1149960902456655913"
                        "1210226007143878679"
                        "1173616916401754123"
                        "1050856866277757071"
                        "1219702424244191275"
                        "1162792878293135400"
                        "1162692854569762827"
                      ];
                    }
                  ];
                };
              };
              callTimer = {
                enable = true;
                allCallTimers = true;
                showRoleColor = true;
                showSeconds = true;
                showWithoutHover = true;
                trackSelf = true;
              };
              translatePlus = {
                enable = true;
                target = "ru";
                toki = true;
                sitelen = true;
                shavian = true;
              };
              alwaysAnimate.enable = true;
              crashHandler.enable = true;
              experiments.enable = true;
              fakeProfileThemes.enable = true;
              fixImagesQuality.enable = true;
              gameActivityToggle.enable = true;
              readAllNotificationsButton.enable = true;
              roleColorEverywhere.enable = true;
              showAllMessageButtons.enable = true;
              showHiddenChannels.enable = true;
              webKeybinds.enable = true;
              webScreenShareFixes.enable = true;
              userPfp.enable = true;
              webContextMenus.enable = true;
            };
          };
        };
      };
    };
  };
}
