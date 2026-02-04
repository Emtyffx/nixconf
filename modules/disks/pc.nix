{
  flake.diskoConfigurations.pc = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_with_Heatsink_1TB_S73JNJ0W908811B";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                name = "ESP";
                size = "2G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                    };

                    "/home" = {
                      mountOptions = [ "compress=zstd" ];
                      mountpoint = "/home";
                    };

                    "/nix" = {
                      mountOptions = [
                        "compress=zstd"
                        "noatime"

                      ];
                      mountpoint = "/nix";
                    };

                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap = {
                        swapfile.size = "20G";
                      };
                    };

                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
