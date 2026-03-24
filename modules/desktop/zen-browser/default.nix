{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      inputs,
      config,
      ...
    }: let
      inherit (lib) flattenAttrsDot;
      search = import ./search-engines.nix {inherit pkgs;};
      extensions = import ./extensions.nix {inherit inputs pkgs;};
      spaces = import ./spaces.nix;
      mods = import ./mods.nix {inherit lib;};
    in {
      hm = {
        programs.zen-browser = {
          enable = true;
          package = inputs.zen-browser.packages.${lib.hostPlatform}.twilight;
          setAsDefaultBrowser = true;

          nativeMessagingHosts = [pkgs.firefoxpwa];

          policies = {
            AutofillAddressEnabled = true;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true; # save webs for later reading
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            OfferToSaveLoginsDefault = false;
            OfferToSaveLogins = false;
            PasswordManagerEnabled = false;
            PDFjs.Enabled = false;
            PictureInPicture.Enabled = true;
            ShowHomeButton = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
              EmailTracking = true;
            };
            FirefoxHome = {
              Pocket = false;
              Snippets = false;
            };
            SearchEngines = {
              Default = "Google";
              Remove = [
                "Amazon.com"
                "Bing"
                "DuckDuckGo"
                "DuckDuckGo Lite"
                "eBay"
                "MetaGer"
                "Mojeek"
                "Perplexity"
                "SearXNG - searx.be"
                "StartPage"
                "Twitter"
                "Wikipedia"
                "Wikipedia (en)"
              ];
            };
            ExtensionSettings = {
              "*" = {
                installation_mode = "allowed";
              };
            };
            GenerativeAI = {
              Enabled = false;
              Chatbot = false;
              LinkPreviews = false;
              TabGroups = false;
              Locked = false;
            };

            HardwareAcceleration = true;
          };

          profiles = {
            "angeldust" = {
              inherit search;
              inherit extensions;
              inherit (spaces) spaces pins;
              inherit (mods) mods;
              pinsForce = false;
              spacesForce = true;

              settings = let
                zenPackage = config.hm.programs.zen-browser.package;
                ffVersion = lib.strings.trim (builtins.readFile (
                  pkgs.runCommand "get-ff-version" {
                    buildInputs = [pkgs.gnugrep];
                  } ''
                    grep -oP 'Milestone=\K[0-9.]+' ${zenPackage}/lib/zen-bin-${lib.getVersion zenPackage}/platform.ini > $out
                  ''
                ));
              in
                flattenAttrsDot {
                  media = {
                    ffmpeg.vaapi.enabled = lib.versionOlder ffVersion "137.0.0";
                    hardware-video-decoding.force-enabled = lib.versionAtLeast ffVersion "137.0.0";
                    rdd-ffmpeg.enabled = lib.versionOlder ffVersion "97.0.0";
                    av1.enabled = true;
                  };
                  gfx.x11-egl.force-enabled = true;
                  widget = {
                    transparent-windows = false;
                    dmabuf.force-enabled = true;
                  };

                  zen = {
                    workspaces.continue-where-left-off = true;
                    pinned-tab-manager.restore-pinned-tabs-to-pinned-url = false;
                    widget.linux.transparency = true;
                    welcome-screen.seen = true;
                    theme.gradient = true;
                  };

                  apz = {
                    overscroll.enabled = true;
                  };
                  general = {
                    smoothScroll = {
                      msdPhysics = {
                        continuousMotionMaxDeltaMS = 12;
                        motionBeginSpringConstant = 600;
                        regularSpringConstant = 650;
                        slowdownMinDeltaMS = 25;
                        slowdownMinDeltaRatio = "2";
                        slowdownSpringConstant = 250;
                      };
                      currentVelocityWeighting = "1";
                      stopDecelerationWeighting = "1";
                    };
                  };
                  mousewheel = {
                    default.delta_multiplier_y = 300;
                  };
                }
                // mods.mods-settings // {"general.smoothScroll" = true;};
            };
          };
        };
      };
    };
  };
}
