{
  self,
  inputs,
  overlays,
  ...
}:
# WARN:
# set only this options
let
  nxosLib = inputs.nixpkgs.lib;
  homeLib = inputs.home-manager.lib;

  nxosModules = with inputs; [
    disko.nixosModules.disko
    lanzaboote.nixosModules.lanzaboote
    home-manager.nixosModules.home-manager
    hyprland.nixosModules.default
    nnf.nixosModules.default
    nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    chaotic.nixosModules.default
    nix-flatpak.nixosModules.nix-flatpak
    nix-index-database.nixosModules.nix-index
    sops-nix.nixosModules.sops
    nixos-cli.nixosModules.nixos-cli
    zapret-presets.nixosModules.presets
    stylix.nixosModules.default
    nix-gaming.nixosModules.wine
    lix-module.nixosModules.default
  ];

  homeModules = with inputs; [
    zen-browser.homeModules.default
    otter-launcher.homeModules.default
    hyprland.homeManagerModules.default
    niri.homeModules.niri
    nixcord.homeModules.nixcord
    chaotic.homeManagerModules.default
    nix-index-database.homeModules.nix-index
    sops-nix.homeManagerModules.sops
  ];
in
  # WARN:
  # touch here only in cases
  rec {
    buildConfiguration = configurationName: {
      hostName ? throw "Set 'hostName'",
      userName ? throw "Set 'userName'",
      hostPlatform ? throw "Set 'hostPlatform'",
      stateVersion ? "26.05",
      hostId ? throw "Set 'hostId'",
      extraModules ? [],
      flakeDir ? "/etc/nixos",
    }: let
      specialArgs = {
        inherit
          self
          inputs
          ;
      };

      pkgs = import inputs.nixpkgs {
        system = hostPlatform;
        config = {
          allowBroken = true;
          allowInsecure = true;
          allowUnfree = true;
          cudaSupport = true;
        };
        inherit overlays;
      };

      # INFO:
      # extend nixpkgs lib
      # with my own functions
      lib = nxosLib.extend (
        _final: _prev:
          {
            inherit
              (homeLib)
              hm
              ;

            inherit
              configurationName
              hostName
              userName
              hostPlatform
              flakeDir
              hostId
              ;
          }
          // (import ./functions.nix {
            inherit
              inputs
              pkgs
              lib
              ;
          })
      );
    in
      # INFO:
      # main system builder
      {
        ${configurationName} = nxosLib.nixosSystem {
          inherit
            pkgs
            lib
            specialArgs
            ;

          modules =
            nxosModules
            ++ extraModules
            ++ [
              self.diskoConfigurations.${configurationName}
              (
                {config, ...}: let
                  sops-update-keys =
                    pkgs.writeShellScriptBin "sops-update-keys"
                    # bash
                    ''
                      for file in $(${nxosLib.getExe pkgs.gnugrep} -lr "sops:" secrets/); do ${nxosLib.getExe pkgs.sops} updatekeys -y $file; done
                    '';
                in {
                  config = {
                    networking = {inherit hostName hostId;};

                    users.users.${userName} = {
                      isNormalUser = true;
                    };

                    home-manager = {
                      extraSpecialArgs = specialArgs;
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      backupFileExtension = "hm.bak";

                      sharedModules =
                        [
                          {
                            home = {
                              inherit (config.system) stateVersion;

                              username = userName;
                              homeDirectory = "/home/${userName}";

                              preferXdgDirectories = true;
                            };

                            sops = let
                              secretSettings = name: {
                                sopsFile = ../secrets/ssh-gpg/hosts/${userName}-ssh.yaml;
                                path = "/home/${userName}/.ssh/id_ed25519${
                                  if name == "angl_ssh_pub"
                                  then ".pub"
                                  else ""
                                }";
                              };
                            in {
                              age.sshKeyPaths = ["/home/${userName}/.ssh/id_ed25519"];
                              defaultSopsFile = ../secrets/secrets.yaml;
                              secrets =
                                nxosLib.mapAttrs (_: secretSettings)
                                (nxosLib.genAttrs [
                                  "angl_ssh_priv"
                                  "angl_ssh_pub"
                                ] (x: x));
                            };
                          }
                        ]
                        ++ homeModules;
                    };

                    sops = {
                      defaultSopsFile = ../secrets/secrets.yaml;
                      age = {
                        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
                        keyFile = "/var/lib/sops-nix/key.txt";
                        generateKey = true;
                      };
                    };

                    environment.systemPackages = [sops-update-keys pkgs.sops];

                    nixpkgs = {inherit hostPlatform;};

                    system = {inherit stateVersion;};
                  };
                }
              )

              (import ./aliases.nix lib)
            ];
        };
      };

    inherit
      nxosLib
      homeLib
      ;
  }
