{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../home/kitty.nix
    # ../home/neovim
    # ../home/sway.nix
    ../home/waybar
    ../home/tmux.nix
    ../home/ranger.nix
    ../home/hyprland
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "paul";
  home.homeDirectory = "/home/paul";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    discord
    obsidian
    powerline-fonts
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    adwaita-fonts
    ripgrep
    obs-studio
    jetbrains.clion
    viber
    adw-gtk3
    qadwaitadecorations-qt6
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-dock
    gnomeExtensions.search-light
    grimblast
    libreoffice
    hunspell
    hunspellDicts.uk_UA
    qalculate-gtk
    pamixer
    wofi
    swappy
    inputs.neovim-config.packages."x86_64-linux".default
  ];
  services.mpd.enable = true;
  services.mpd.musicDirectory = "/home/paul/Music/";
  services.mpd.extraConfig = ''
    audio_output {
      type "pipewire"
      name "Pipewire"
    }
  '';
  # install flatpak apps
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "us.zoom.Zoom"
    "org.chromium.Chromium"
    "org.telegram.desktop"
    "com.viber.Viber"
    "com.spotify.Client"
  ];

  # enable font configuration
  fonts.fontconfig.enable = true;
  dconf.enable = true;
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "Vitals@CoreCoding.com"
        "dash-to-dock@micxgx.gmail.com"
        # "search-light@icedman.github.com"
        "gsconnect@andyholmes.github.io"
      ];
    };
    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      style-dash-to-dock = 2;
    };
    "org/gnome/shell/extensions/vitals" = {
      show-gpu = true;
    };
  };
  programs.gh.enable = true;
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/paul/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables = {
  #   # EDITOR = "emacs";
  #   GTK_THEME = "adw-gtk3-dark";
  #   XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
  # };

  # setup git
  programs.git = {
    enable = true;
    userEmail = "p.verbytsky@gmail.com";
    userName = "Emtyffx";
  };

  # Removing until gnome 48
  # programs.ghostty = {
  #   enable = true;
  #   settings = {
  #     gtk-titlebar = true;
  #     font-size = 10;
  #     theme = "catppuccin-mocha";
  #     background-opacity = 0.8;
  #   };
  # };

}
