{ config, ... }:
let
  nixosModules = config.flake.modules.nixos;
  diskoModules = config.flake.diskoConfigurations;
  meta = config.flake.meta;
in
{
  configurations.nixos.pc = {
    system = "x86_64-linux";
    modules = [
      nixosModules.pc
      diskoModules.pc
      (
        {
          config,
          lib,
          pkgs,
          modulesPath,
          ...
        }:
        {
          boot.initrd.availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "usb_storage"
            "sd_mod"
            "sr_mod"
          ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [
            "kvm-amd"
            "v4l2loopback"
          ];
          boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
          # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
          # (the default) this is the recommended approach. When using systemd-networkd it's
          # still possible to use this option, but it's recommended to use it in conjunction
          # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
          networking.useDHCP = lib.mkDefault true;
          # networking.interfaces.enp16s0f4u2u4u5.useDHCP = lib.mkDefault true;
          # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
          # networking.interfaces.wlp7s0.useDHCP = lib.mkDefault true;

          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
          home-manager.users.${meta.owner.username} = {

            hyprland.monitors = [
              {
                name = "DP-4";
                width = 3840;
                height = 2160;
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
              {
                name = "DP-5";
                width = 3840;
                height = 2160;
                refreshRate = 60;
                x = -3072;
                y = 0;
                scale = 1.25;
                transform = "normal";
                vrr = 0;
                hdr = false;
                primary = false;
                enabled = true;

              }
              {
                name = "DP-1";
                width = 3840;
                height = 2160;
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
              {
                name = "DP-2";
                width = 3840;
                height = 2160;
                refreshRate = 60;
                x = -3072;
                y = 0;
                scale = 1.25;
                transform = "normal";
                vrr = 0;
                hdr = false;
                primary = false;
                enabled = true;

              }
            ];
          };
        }
      )
    ];
  };
}
