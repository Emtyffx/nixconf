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
    sddm
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
        sddm

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
          "kvm"
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
        qemu
        qemu_kvm
        libguestfs
        qemu-utils
        quickemu
        quickgui

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
        GSETTINGS_SCHEMA_DIR = lib.mkForce "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
      };

      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true;

        fwupd.enable = true;
      };

      programs.dconf.enable = true;
      services.dbus.packages = [ pkgs.gsettings-desktop-schemas ];
      environment.sessionVariables.GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
      # enable postgresql(for development purposes)

      services.postgresql = {
        enable = true;
        enableTCPIP = true; # <--- Add this!
        authentication = pkgs.lib.mkOverride 10 ''
          #type database  DBuser  address       auth-method
          local all       all                   trust 
          host  all       all     127.0.0.1/32  trust
          host  all       all     ::1/128       trust 
        '';
      };
      programs.nix-ld.enable = true;

      services.envfs.enable = true;
      # virtualisation.libvirtd = {
      #   enable = true;
      #   qemu = {
      #     package = pkgs.qemu_kvm;
      #     runAsRoot = true;
      #     swtpm.enable = true;
      #   };
      # };

      services.gvfs.enable = true;
    };
}
