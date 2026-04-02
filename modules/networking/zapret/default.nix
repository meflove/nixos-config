{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      config,
      ...
    }: let
      cfgZapret = config.services.zapret;
    in {
      services.zapret = {
        enable = true;
        configureFirewall = lib.mkForce false;

        sf_presets = {
          enable = true;

          preset = "renixos";
        };
      };

      networking.nftables.tables.zapret = {
        family = "inet";
        content = let
          httpParams = lib.optionalString (
            cfgZapret.httpMode == "first"
          ) "ct original packets 1-6";
          udpPorts = cfgZapret.udpPorts |> lib.concatStringsSep ",";
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
  };
}
