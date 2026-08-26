{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {config, ...}: {
      sops = {
        secrets = {
          tg_ws_proxy = {};
        };
      };
      services.proxy-suite = {
        enable = true;

        proxy.enable = false;

        tgWsProxy = {
          # INFO:
          # connect via this link
          # https://t.me/proxy?server=127.0.0.1&port=1443&secret=dda95d4572bdc10eebaa57192dd9384095
          enable = true;

          host = "127.0.0.1";
          port = 1443;

          secretFile = config.sops.secrets.tg_ws_proxy.path;
        };

        zapret = {
          enable = true;

          configName = "general (ALT12)";
          gameFilter = "all";

          listExclude = [
            "chat.z.ai"
            "z.ai"
            "api.z.ai"

            "jj-vcs.dev"
            "docs.jj-vcs.dev"

            "carapace.sh"

            "fandom.com"

            "nushell.sh"

            "dl.winehq.org"

            "static.crates.io"
            "crates.io"

            "zellij.dev"

            "lazyvim.org"

            "nix.dev"
            "cachix.org"
            "nixos-cache-proxy.cofob.dev"
            "nixos.org"
            "cache.nixos.org"
            "releases.nixos.org"
            "cache.nixos.org"
            "channels.nixos.org"
            "search.nixos.org"
            "cache.garnix.io"
            "garnix-cache.com"
            "cache.nixos-cuda.org"
            "git.lix.systems"
            "m1.ppy.sh"
            "snix.dev"
            "dl.genymotion.com"
            "chaotic.cx"
          ];
        };
      };
    };
  };
}
