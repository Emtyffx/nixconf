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
      ];

      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };
      # enable themes (gtk, qt)
      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
        cursorTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
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
    };

}
