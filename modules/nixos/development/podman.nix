{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;

    dockerCompat = true;
    dockerSocket.enable = true;

    defaultNetwork.settings.dns_enabled = true;
  };

  hardware.nvidia-container-toolkit.enable = true;

  environment.variables.DBX_CONTAINER_MANAGER = "podman";
  users.extraGroups.podman.members = [ "angeldust" ];

  environment.systemPackages = with pkgs; [
    nvidia-docker

    podman-compose
    podman-tui

    docker-compose
  ];
}
