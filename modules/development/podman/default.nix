{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {pkgs, ...}: {
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

          extraPackages = with pkgs; [
            podman-compose
            podman-tui
          ];
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
