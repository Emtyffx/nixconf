let
  theme = import ./themes/everforest.nix;
in
{
  imports = [
    ./hyprland.nix
    # ./hyprpaper.nix # replaced with swww
    ./swww.nix

    ./hyprlock.nix
    ./wlogout.nix
    ./rofi
    ./dunst.nix
    ./hypridle.nix
    ./waybar
  ];
  myWaybar.enable = true;
  myWaybar.colors = theme.colors;
  myHyprland.enable = true;
  myHyprland.wallpaper = theme.wallpaper;
}
