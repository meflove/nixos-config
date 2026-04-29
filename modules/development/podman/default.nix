{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      ...
    }: {
      users.users = {
        ${lib.userName} = {
          extraGroups = [
            "docker"
            "podman"
          ];
        };
      };

      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          dockerSocket.enable = true;

          autoPrune = {
            enable = true;
            flags = [
              "--all"
              "--volumes"
            ];
          };

          defaultNetwork.settings.dns_enabled = true;

          extraPackages = lib.attrValues {
            inherit
              (pkgs)
              podman-compose
              podman-tui
              ;
          };
        };
      };

      hardware.nvidia-container-toolkit = {
        enable = true;
      };

      environment = {
        variables.DBX_CONTAINER_MANAGER = "podman";
      };
    };
  };
}
