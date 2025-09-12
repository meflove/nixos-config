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
  users.extraGroups.podman.members = [ "xnm" ];

  environment.systemPackages = with pkgs; [
    nvidia-docker
    nerdctl

    distrobox
    qemu
    lima

    podman-compose
    podman-tui

    docker-compose
    lazydocker
  ];
}
