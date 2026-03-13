{
  inputs,
  pkgs,
  ...
}: {
  force = true;

  settings = {
    "uBlock0@raymondhill.net".settings = {
      selectedFilterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"
        "easylist"
        "easyprivacy"
        "urlhaus-1"
        "plowe-0"
        "RUS-0"
        "RUS-1"
      ];
      whitelist = [
        "chrome-extension-scheme"
        "moz-extension-scheme"
        "tonordersitye.com"
      ];
      dynamicFilteringString = "behind-the-scene * * noop\nbehind-the-scene * inline-script noop\nbehind-the-scene * 1p-script noop\nbehind-the-scene * 3p-script noop\nbehind-the-scene * 3p-frame noop\nbehind-the-scene * image noop\nbehind-the-scene * 3p noop";
      urlFilteringString = "";
      hostnameSwitchesString = "no-large-media: behind-the-scene false\nno-csp-reports: * true";
      userFilters = "";
    };
  };
  packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
    ublock-origin
    bitwarden
    darkreader
    zen-internet
    offline-qr-code-generator
    sponsorblock
    multi-account-containers
    clearurls
    auto-tab-discard
    canvasblocker
    enhanced-h264ify
    return-youtube-dislikes
    # enhancer-for-youtube
    stylus
    violentmonkey
    media-url-timestamper
  ];
}
