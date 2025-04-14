{ lib, pkgs, ... }:
{
  home.packages = lib.mkAfter (
    with pkgs;
    [
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.vitals
      gnomeExtensions.dash-to-dock
      gnomeExtensions.search-light
    ]
  );

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
}
