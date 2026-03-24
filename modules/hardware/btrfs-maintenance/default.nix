{
  flake = _: {
    nixosModules.${baseNameOf ./.} = {
      pkgs,
      lib,
      config,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        btrfs-progs
      ];

      services = lib.mkIf (config.boot.supportedFilesystems ? "btrfs") {
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
  };
}
