{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.nixos.hardware.btrfs-maintenance;
in {
  options.${namespace}.nixos.hardware.btrfs-maintenance = {
    enable = lib.mkEnableOption "Btrfs maintenance tools and services" // {default = true;};
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btrfs-progs
    ];

    services = {
      btrfs.autoScrub = {
        enable = true;
      };

      beesd.filesystems.root = {
        spec = "/";
        hashTableSizeMB = 256;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "5.0"
          "--throttle-factor"
          "1.0"
        ];
      };
    };
  };
}
