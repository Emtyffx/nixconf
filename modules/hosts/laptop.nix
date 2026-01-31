{ config, ... }:
let
  nixosModules = config.flake.modules.nixos;
  diskoModules = config.flake.diskoConfigurations;
  meta = config.flake.meta;
in
{
  configurations.nixos.laptop = {

    system = "x86_64-linux";
    modules = [
      # diskoModules.laptop
      nixosModules.laptop
      diskoModules.laptop
      (
        {
          config,
          lib,
          pkgs,
          modulesPath,
          ...
        }:
        {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
          ];

          boot.initrd.availableKernelModules = [
            "xhci_pci"
            "thunderbolt"
            "vmd"
            "ahci"
            "nvme"
            "usb_storage"
            "sd_mod"
          ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ ];
          boot.extraModulePackages = [ ];

          # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
          # (the default) this is the recommended approach. When using systemd-networkd it's
          # still possible to use this option, but it's recommended to use it in conjunction
          # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
          # networking.interfaces.enp43s0.useDHCP = lib.mkDefault true;
          # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

          home-manager.users.${meta.owner.username} = {

            hyprland.monitors = [
              {
                name = "eDP-1";
                width = 1920;
                height = 1080;
                refreshRate = 60;
                x = 0;
                y = 0;
                scale = 1.25;
                transform = "normal";
                vrr = 0;
                hdr = false;
                primary = true;
                enabled = true;

              }
            ];
          };

        }
      )

    ];
  };
}
