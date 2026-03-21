{
  config,
  inputs,
  ...
}:
let
  meta = config.flake.meta;
  homeModules = config.flake.homeModules;
in
{
  flake.homeConfigurations.${meta.owner.username} =
    { lib, pkgs, ... }:
    let
      figma-linux-font-helper = pkgs.callPackage ../../pkgs/figma-linux-font-helper/package.nix { };
      en-croissant = pkgs.callPackage ../../pkgs/en-croissant/package.nix { };
      prism-launcher = inputs.prism-launcher.packages.${pkgs.hostPlatform.system}.default;
      zen-browser = inputs.zen-browser-flake.packages.${pkgs.hostPlatform.system}.default;
      custom-gtk-theme = pkgs.callPackage ../../pkgs/gnome4x-custom/package.nix meta.defaults.theme.gtk-theme-args;
      custom-icon-theme = pkgs.callPackage ../../pkgs/flat-remix-icon-theme-custom/package.nix meta.defaults.theme.icon-theme-args;
    in
    {
      imports = [
        homeModules.kitty
        homeModules.wlogout
        homeModules.rofi
        homeModules.nvim
        homeModules.hyprland
        homeModules.hyprlock
        homeModules.hypridle
        homeModules.waybar
        homeModules.zsh
        homeModules.development
        homeModules.nh
        homeModules.tmux
        homeModules.dunst
        homeModules.texlive
      ];
      home = {
        username = meta.owner.username;
        homeDirectory = "/home/${meta.owner.username}";

        stateVersion = meta.defaults.stateVersion;
      };

      programs.gh.enable = true;

      programs.git = {
        enable = true;
        userName = meta.owner.name;
        userEmail = meta.owner.email;
        settings = {

          core.editor = meta.defaults.editor;
        };
      };

      programs.lazygit.enable = true;
      programs.btop.enable = true;

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };

      home.packages = with pkgs; [
        wl-clipboard
        firefox
        ffmpeg
        prism-launcher
        zen-browser
        loupe
        zoom-us
        telegram-desktop
        obs-studio
        viber
        discord
        evince
        libreoffice
        obsidian
        qalculate-gtk

        gsettings-desktop-schemas
        spotify
        figma-linux-font-helper
        logseq
        en-croissant
        gnome-boxes
        custom-icon-theme
        custom-gtk-theme

      ];

      # figma font helper service
      # systemd.user.services.figma-fonthelper = {
      #   Unit = {
      #     Description = "Font Helper for Figma";
      #   };
      #   Install.WantedBy = [ "graphical-session.target" ];
      # };

      home.pointerCursor = {
        name = "Flat-Remix-${lib.toSentenceCase meta.defaults.theme.icon-theme-args.name}-Dark";
        package = custom-icon-theme;
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };
      # enable themes (gtk, qt)
      gtk = {
        enable = true;
        theme = {
          name = "GNOME-4X-${meta.defaults.theme.gtk-theme-args.name}";
          package = custom-gtk-theme;
        };
        cursorTheme = {
          name = "Flat-Remix-${lib.toSentenceCase meta.defaults.theme.icon-theme-args.name}-Dark";
          package = custom-icon-theme;
        };
        iconTheme = {
          name = "Flat-Remix-${lib.toSentenceCase meta.defaults.theme.icon-theme-args.name}-Dark";
          package = custom-icon-theme;
        };
        gtk3.extraConfig = {
          gtk-decoration-layout = ":";
          gtk-application-prefer-dark-theme = 1;
        };
        gtk4.extraConfig = {
          gtk-decoration-layout = ":";
          gtk-application-prefer-dark-theme = 1;
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk3";
        style = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
      };
      home.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "gtk3";
        QT_QPA_PLATFORM = "wayland;xcb";
      };
      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };

      xdg.portal.enable = true;
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
      };
    };

}
