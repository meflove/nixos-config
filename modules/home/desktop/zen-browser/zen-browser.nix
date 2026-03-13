{
  pkgs,
  inputs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.angl) flattenAttrsDot;

  cfg = config.home.${namespace}.desktop.zen-browser;

  search = import ./search-engines.nix {inherit pkgs;};
  extensions = import ./extensions.nix {inherit inputs pkgs;};
  spaces = import ./spaces.nix;
  mods = import ./mods.nix {inherit lib;};
in {
  options.home.${namespace}.desktop.zen-browser = {
    enable =
      lib.mkEnableOption "enable Zen Browser with custom configuration"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
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
            zenPackage = config.programs.zen-browser.package;
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
                dmabuf.force-enabled = true;
                transparent-windows = true;
              };
              zen = {
                workspaces.continue-where-left-off = true;
                pinned-tab-manager.restore-pinned-tabs-to-pinned-url = false;
                widget.linux.transparency = true;
                welcome-screen.seen = true;
                theme.gradient = true;
              };
            }
            // mods.mods-settings;
        };
      };
    };
  };
}
