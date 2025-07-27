{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = 0.70;
      # background_blur = 1;
      confirm_os_window_close = 0;
      font_size = 12;
    };
    shellIntegration.enableBashIntegration = true;
  };
}
