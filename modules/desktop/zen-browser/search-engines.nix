{pkgs, ...}: {
  force = true;
  default = "google";
  privateDefault = "ddg";

  engines = {
    "Nix Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["np"];
    };
    "Nix Options" = {
      urls = [
        {
          template = "https://search.nixos.org/options";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["no"];
    };
    "Home-Manager Options" = {
      urls = [
        {
          template = "https://home-manager-options.extranix.com";
          params = [
            {
              name = "release";
              value = "master";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["ho"];
    };
    "NixOS Wiki" = {
      urls = [
        {
          template = "https://wiki.nixos.org/w/index.php";
          params = [
            {
              name = "search";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["nw"];
    };
    "Noogle.dev" = {
      urls = [
        {
          template = "https://noogle.dev/q";
          params = [
            {
              name = "term";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      definedAliases = ["noo"];
    };
    "Perplexity" = {
      urls = [
        {
          template = "https://www.perplexity.ai/search";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
            {
              name = "s";
              value = "o";
            }
          ];
        }
      ];
      definedAliases = ["@perp"];
    };
    "Ru to En" = {
      urls = [
        {
          template = "https://translate.google.com/";
          params = [
            {
              name = "sl";
              value = "ru";
            }
            {
              name = "tl";
              value = "en";
            }
            {
              name = "text";
              value = "{searchTerms}";
            }
            {
              name = "op";
              value = "translate";
            }
          ];
        }
      ];
      definedAliases = ["ru"];
    };
    "En to Ru" = {
      urls = [
        {
          template = "https://translate.google.com/";
          params = [
            {
              name = "sl";
              value = "en";
            }
            {
              name = "tl";
              value = "ru";
            }
            {
              name = "text";
              value = "{searchTerms}";
            }
            {
              name = "op";
              value = "translate";
            }
          ];
        }
      ];
      definedAliases = ["en"];
    };
    "RUTracker" = {
      urls = [
        {
          template = "https://rutracker.org/forum/tracker.php";
          params = [
            {
              name = "nm";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      definedAliases = ["rut"];
    };
  };
}
