{ config, inputs, ... }:
let
  meta = config.flake.meta;
  homeConfigurations = config.flake.homeConfigurations;
  inherit (config.flake.modules.nixos) base;
  inherit (config.flake.modules.nixos) hyprland;
  inherit (config.flake.modules.nixos) nvidia;
  inherit (config.flake.modules.nixos) printer;
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
        allowedTCPPorts = [
          22
          80
        ];
      };
      programs.${meta.defaults.shell}.enable = true;

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
        glib
        gtk2
        gtk3
        gtk4
        gsettings-desktop-schemas
        adwaita-icon-theme
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${meta.owner.username} = {
          imports = [
            homeConfigurations.${meta.owner.username}
          ];
        };
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
