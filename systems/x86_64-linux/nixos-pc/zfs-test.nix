{
  disko.devices = {
    disk = {
      intel-ssd = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-INTEL_SSDPEKKW128G8_BTHH82310Z37128A";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "ztest";
              };
            };
          };
        };
      };
    };
    zpool = {
      ztest = {
        type = "zpool";

        options = {
          ashift = "12";
          autotrim = "on";
        };

        rootFsOptions = {
          compression = "zstd";
          atime = "off";
          mountpoint = "none";
        };

        mountpoint = "/data";

        datasets = {
          test = {
            type = "zfs_fs";
            mountpoint = "/data";
            options = {
              recordsize = "128K";
            };
          };

          test2 = {
            type = "zfs_fs";
            mountpoint = "/data2";
            options = {
              recordsize = "16K";
              compression = "lz4";
            };
          };
        };

        postCreateHook = "zfs snapshot ztest/test@blank";
      };
    };
  };
}
