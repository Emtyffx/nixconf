{ config, inputs, ... }:
let
  meta = config.flake.meta;
  homeConfigurations = config.flake.homeConfigurations;
  inherit (config.flake.modules.nixos)
    printer
    base
    hyprland
    nvidia
    steam
    ;
in
{
  flake.modules.nixos.pc =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        base
        hyprland
        nvidia
        printer
        steam
      ];
      users.users.${meta.owner.username} = {
        isNormalUser = true;
        home = "/home/${meta.owner.username}";
        extraGroups = [
          "networkmanager"
          "wheel"
          "audio"
          "video"
          "docker"
          "libvirtd"
          "tty"
          "dialout"
        ];
        initialPassword = "changeme";
        shell = pkgs.${meta.defaults.shell};

      };

      networking.firewall = {
        enable = true;
      };
      programs.${meta.defaults.shell}.enable = true;

      # enable latest kernel version
      boot.kernelPackages = pkgs.linuxPackages_latest;
      hardware.enableRedistributableFirmware = true;

      services.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;

      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      services.blueman.enable = true;

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
      ];

      environment.systemPackages = with pkgs; [
        pavucontrol
        pamixer
        bibata-cursors
        wl-clipboard
        xfce.thunar
        gtk2
        gtk3
        gtk4
        gsettings-desktop-schemas
        adwaita-icon-theme
        glib
        gcc
        cloudflare-warp
      ];

      services.cloudflare-warp.enable = true;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${meta.owner.username} = {
          imports = [
            homeConfigurations.${meta.owner.username}
          ];
        };
      };

      environment.variables = {
        GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
      };

      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true;

        fwupd.enable = true;
      };

      programs.dconf.enable = true;

      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

    };
}
