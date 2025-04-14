{ ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      gtk-titlebar = true;
      font-size = 10;
      theme = "catppuccin-mocha";
      background-opacity = 0.8;
    };
  };
}
