{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = 0.55;
      background_blur = 1;
      confirm_os_window_close = 0;
    };
    shellIntegration.enableBashIntegration = true;
  };
}
