{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ wofi ];
  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty";
      startup = [
        # setup wallpaper
        { command = "swaymsg output \"*\" bg ${./bg.jpg} fill"; }
      ];
      keybindings = lib.mkOptionDefault {
        "${modifier}+r" = "exec wofi --show drun";
        "${modifier}+q" = "kill";
      };
      bars = [
        {
          command = "waybar";
        }
      ];
      gaps = {
        inner = 20;
      };
      input = {
        "*" = {
          xkb_layout = "us,ru,ua";
          xkb_options = "grp:win_space_toggle";
        };
      };
      window = {
        titlebar = false;
      };
      workspaceOutputAssign = [
        {
          output = "*";
          workspace = "1";
        }
      ];
    };
  };

}
