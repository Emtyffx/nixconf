rec {
  wallpaper = "${../non-nix/wallpaper.png}";
  colors = rec {
    red-dim = "#cc241d";
    green-dim = "#98971a";
    yellow-dim = "#d79921";
    blue-dim = "#458588";
    purple-dim = "#b16286";
    aqua-dim = "#689d6a";
    gray-dim = "#a89984";
    orange-dim = "#d65d0e";

    gray = "#928374";
    red = "#fb4934";
    green = "#b8bb26";
    yellow = "#fabd2f";
    blue = "#83a598";
    purple = "#d3869b";
    aqua = "#8ec07c";
    orange = "#fe8019";

    bg0-h = "#1d2021";
    bg0-s = "#32302f";
    bg0 = "#282828";
    bg1 = "#3c3836";
    bg2 = "#504945";
    bg3 = "#665c54";
    bg4 = "#7c6f64";

    fg0 = "#fbf1c7";
    fg1 = "#ebdbb2";
    fg2 = "#d5c4a1";
    fg3 = "#bdae93";
    fg4 = "#a89984";

    fg = fg1;

    bg = bg0;

  };

  gtk-theme-args = {
    name = "gruvbox_aqua";
    accent = colors.aqua;
    text = colors.bg0;
  };

  icon-theme-args = {
    name = "gruvboxaqua";
    accent = colors.aqua;
    accent-light = colors.aqua-dim;

    text = colors.fg;
  };

}
