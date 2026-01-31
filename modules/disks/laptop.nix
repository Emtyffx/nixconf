{
  flake.diskoConfigurations.laptop = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";

          device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNX1T318635X";

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
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";
                  settings = {
                    allowDiscards = true;
                  };

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
  };
}
