# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../users/default.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  #
  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # enable dbus
  services.dbus.enable = true;
  # Enable the GNOME Desktop Environment
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = with pkgs; [ mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
    '';
  };
  services.xserver.displayManager.gdm.enable = true;

  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.enable = true;
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
  programs.hyprland.enable = true;

  # enable flatpak
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru,ua";
    variant = "";
  };
  services.cloudflare-warp = {
    enable = true;
  };
  # xdg portals
  # xdg.portal = {
  #   xdgOpenUsePortal = true;
  #   enable = true;
  #   # lxqt.enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-gnome
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-hyprland
  #     pkgs.kdePackages.xdg-desktop-portal-kde
  #     pkgs.xdg-desktop-portal-wlr
  #   ];
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  # }; # enable git
  programs.git = {
    enable = true;
  };
  # enable opengl
  hardware.opengl = {
    enable = true;
  };

  # enable sway
  programs.sway.enable = true;
  # enable graphics(nvidia)
  hardware.graphics.enable = true;
  # enable libvirtd
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplip ];
  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_LaserJet_1320";
        location = "Home";
        deviceUri = "socket://192.168.20.3:9100";
        model = "drv:///hp/hpcups.drv/hp-laserjet_1320.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true; # The open drivers are generally recommended these days
    modesetting.enable = true; # Starts the nvidia with kms, ensuring that there is no tty flicker and enabling a variety of important things down the stack
    powerManagement.enable = true; # Optional, this fixes suspend for me
    powerManagement.finegrained = true;
    # This is the default anyway
    package = config.boot.kernelPackages.nvidiaPackages.beta; # This setting is for datacenter GPUs, not stuff you'd actually render desktops on
    # hardware.nvidia.nvidiaPersistenced = false;
    # See above
    # hardware.nvidia.forceFullCompositionPipeline = false;
    prime = {
      amdgpuBusId = "PCI:10:0:0";
      nvidiaBusId = "PCI:1:0:0";
      offload.enable = true;
    };
  };
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # enable polkit(for home manager management of sway)
  security.polkit.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.paul = {
    isNormalUser = true;
    description = "Pavel Verbytsky";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    neovim
    nodejs_24
    wineWowPackages.stable
    winetricks
    wineWowPackages.waylandFull
    cloudflare-warp
    nixfmt-rfc-style
    python313
    gcc
    cmake
    clang
    shared-mime-info
    desktop-file-utils
    # thorium
    kdePackages.xwaylandvideobridge
    librewolf
    wl-clipboard
    gnome-boxes
    gnome-tweaks
    appimage-run
    xdg-utils
    postgresql
  ];

  # enable postgres(for development)
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    package = pkgs.postgresql;
    authentication = pkgs.lib.mkOverride 10 ''
      local all    all   trust
      host  all    all   127.0.0.1/32  trust
      host  all    all   ::1/128       trust
    '';
  };
  # system variables
  environment.sessionVariables = {
    SUDO_EDITOR = "nvim";
    GSK_RENDERER = "ngl";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  #enable the ssh agent
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = rec {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/current-system/sw/bin"
  '';

  # configure envfs(for shebangs)

  services.envfs.enable = true;

  #configure nh(for nh os switch)
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 3 --keep-since 4d";
    flake = "/home/paul/nixconf";
  };
  nix.settings.trusted-users = [
    "root"
    "paul"
    "@wheel"
  ];
}
