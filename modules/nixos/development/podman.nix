{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.development.podman;
in {
  options.${namespace}.nixos.development.podman = {
    enable =
      lib.mkEnableOption "enable Podman container management and Docker compatibility"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;

        dockerCompat = true;
        dockerSocket.enable = true;

        defaultNetwork.settings.dns_enabled = true;
      };
    };

    hardware.nvidia-container-toolkit = {
      enable = false;
    };

    users.extraGroups.podman.members = ["angeldust"];

    environment = {
      variables.DBX_CONTAINER_MANAGER = "podman";
      systemPackages = with pkgs; [
        nvidia-docker

        podman-compose
        podman-tui

        docker-compose
      ];
    };
  };
}
