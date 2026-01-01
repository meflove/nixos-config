{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.core.zapret;
  cfgZapret = config.services.zapret;
in {
  options.${namespace}.nixos.core.zapret = {
    enable =
      lib.mkEnableOption ''
        enable zapret service
      ''
      // {default = true;};
  };

  config = mkIf cfg.enable {
    services.zapret = {
      enable = true;
      configureFirewall = lib.mkForce false;
      # whitelist = [
      #   # Dicord domains
      #   "airhorn.solutions"
      #   "airhornbot.com"
      #   "bigbeans.solutions"
      #   "dis.gd"
      #   "discord-activities.com"
      #   "discord-attachments-uploads-prd.storage.googleapis.com"
      #   "discord.co"
      #   "discord.com"
      #   "discord.design"
      #   "discord.dev"
      #   "discord.gg"
      #   "discord.gift"
      #   "discord.gifts"
      #   "discord.media"
      #   "discord.new"
      #   "discord.store"
      #   "discord.tools"
      #   "discordactivities.com"
      #   "discordapp.com"
      #   "discordapp.io"
      #   "discordapp.net"
      #   "discordcdn.com"
      #   "discordmerch.com"
      #   "discordpartygames.com"
      #   "discordsays.com"
      #   "discordstatus.com"
      #   "hammerandchisel.ssl.zendesk.com"
      #   "watchanimeattheoffice.com"
      #
      #   # Soundcloud domains
      #   "sndcdn.com"
      #   "soundcloud.cloud"
      #   "soundcloud.com"
      # ];
      sf_presets = {
        enable = true;

        preset = "renixos";
      };
    };

    networking.nftables.tables.zapret = {
      family = "inet";
      content = let
        httpParams = lib.optionalString (
          cfg.httpMode == "first"
        ) "ct original packets 1-6";
        udpPorts = lib.concatStringsSep "," cfgZapret.udpPorts;
      in ''
        chain postrouting {
          type filter hook postrouting priority mangle; policy accept;

          # HTTPS traffic
          tcp dport 443 ct original packets 1-6 mark and 0x40000000 != 0x40000000 counter queue num ${cfgZapret.qnum} bypass

          ${lib.optionalString cfgZapret.httpSupport ''
          # HTTP traffic
          tcp dport 80 ${httpParams} mark and 0x40000000 != 0x40000000 counter queue num ${cfgZapret.qnum} bypass
        ''}

          ${lib.optionalString cfgZapret.udpSupport ''
          # UDP traffic
          udp dport { ${udpPorts} } mark and 0x40000000 != 0x40000000 counter queue num ${cfgZapret.qnum} bypass
        ''}
        }
      '';
    };
  };
}
