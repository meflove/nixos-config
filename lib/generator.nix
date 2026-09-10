{
  inputs,
  overlays,
  self,
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
    chaotic.nixosModules.default
    nix-flatpak.nixosModules.nix-flatpak
    nix-index-database.nixosModules.nix-index
    sops-nix.nixosModules.sops
    nix-secrets.nixosModules.default
    nixos-cli.nixosModules.nixos-cli
    proxy-suite-flake.nixosModules.default
    stylix.nixosModules.default
    nix-gaming.nixosModules.wine
    linuwowo.nixosModules.default
    nix-ld.nixosModules.nix-ld
    lix-module.nixosModules.default
    steam-config-nix.nixosModules.default
    ncro.nixosModules.default
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
    nix-secrets.homeManagerModules.default
    steam-config-nix.homeModules.default
    angeldust-nix-packages.homeModules.default
  ];
in
  # WARN:
  # touch here only in cases
  rec {
    buildConfiguration = configurationName: {
      extraModules ? [],
      flakeDir ? "/etc/nixos",
      hostId ? throw "Set 'hostId'",
      hostName ? throw "Set 'hostName'",
      hostPlatform ? throw "Set 'hostPlatform'",
      stateVersion ? "26.05",
      userName ? throw "Set 'userName'",
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
                {config, ...}: {
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
                          }
                        ]
                        ++ homeModules;
                    };

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

    # INFO: pure helpers for flake-parts modules (flake-file.inputs config);
    # imported without pkgs — only functions that do not need it are taken
    inherit
      (import ./functions.nix {lib = nxosLib;})
      mkNativeInputs
      ;
  }
