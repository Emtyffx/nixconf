{
  colors = rec {
    # === Gruvbox Colors ===

    # Warm colors
    flamingo = "#FB4934";
    peach = "#FE8019";
    red = "#FB4934";
    maroon = "#B16286";
    yellow = "#FABD2F";
    pink = "#D3869B";

    # Cool colors
    green = "#B8BB26";
    teal = "#8EC07C";
    sky = "#83A598";
    sapphire = "#458588";
    blue = "#83A598";

    # Neutral colors
    lavender = "#EBDBB2";
    text = "#EBDBB2";
    subtext1 = "#BDAE93";
    subtext0 = "#A89984";
    overlay2 = "#665C54";
    overlay1 = "#504945";
    overlay0 = "#3C3836";
    surface2 = "#282828";
    surface1 = "#1D2021";
    surface0 = "#1D2021";
    base = "#282828";
    mantle = "#1D2021";
    crust = "#1D2021";
    border = sky;
    main_color = sky;
  };
  wallpaper = ./wallpapers/gruvbox.png;
  kittyTheme = ./kitty-themes/gruvbox-dark.conf;
}
