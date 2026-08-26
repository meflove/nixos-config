{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      lib,
      config,
      ...
    }: let
      restartUnits =
        config.services.openvpn.servers
        |> lib.attrNames
        |> lib.map (openvpnConf: "openvpn-${openvpnConf}");
    in {
      sops = {
        secrets = lib.flattenSecrets {
          openvpn = {
            aquanter =
              lib.genAttrs [
                "ip"
                "port"
                "verify"
                "cert"
                "key"
                "ca"
                "tls_crypt"
              ]
              (_: {inherit restartUnits;});
          };
        };

        templates."aquanter.ovpn" = {
          content = ''
            client
            proto udp
            explicit-exit-notify
            remote ${config.sops.placeholder."openvpn/aquanter/ip"} ${config.sops.placeholder."openvpn/aquanter/port"}
            dev tun
            resolv-retry infinite
            nobind
            persist-key
            persist-tun
            remote-cert-tls server
            verify-x509-name ${config.sops.placeholder."openvpn/aquanter/verify"}
            auth SHA256
            auth-nocache
            cipher AES-128-GCM
            tls-client
            tls-version-min 1.2
            tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
            ignore-unknown-option block-outside-dns
            setenv opt block-outside-dns
            verb 3

            ${config.sops.placeholder."openvpn/aquanter/cert"}

            ${config.sops.placeholder."openvpn/aquanter/key"}

            ${config.sops.placeholder."openvpn/aquanter/ca"}

            ${config.sops.placeholder."openvpn/aquanter/tls_crypt"}
          '';
        };
      };

      programs.throne = {
        enable = true;
        tunMode.enable = true;
      };

      services.openvpn = {
        restartAfterSleep = true;
        servers = {
          aquanter = {
            autoStart = true;
            updateResolvConf = true;
            config = "config ${config.sops.templates."aquanter.ovpn".path}";
          };
        };
      };

      environment.sessionVariables = {
        no_proxy = "127.0.0.1";
      };
    };
  };
}
