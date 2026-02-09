{ inpust, config, ... }:
{
  flake.homeModules.dunst =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        libnotify
      ];
      services.dunst = {
        enable = true;
        settings = {
          global = {
            monitor = 0;
            follow = "mouse";
            width = 300;
            height = 300;
            origin = "top-right";
            offset = "10x50";
            scale = 0;
            notification_limit = 0;

            progress_bar = true;
            progress_bar_height = 10;
            progress_bar_frame_width = 1;
            progress_bar_min_width = 150;
            progress_bar_max_width = 300;

            indicate_hidden = true;
            separator_height = 2;
            padding = 8;
            horizontal_padding = 10;
            text_icon_padding = 0;
            separator_color = "frame";

            sort = true;
            idle_threshold = 120;

            font = "Monospace 10";
            line_height = 0;
            markup = "full";
            format = "<b>%s</b>\n%b";
            alignment = "left";
            vertical_alignment = "center";
            show_age_threshold = 60;
            ellipsize = "middle";
            ignore_newline = false;
            stack_duplicates = true;
            hide_duplicate_count = false;
            show_indicators = true;

            icon_position = "left";
            min_icon_size = 0;
            max_icon_size = 64;
            icon_path = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/16x16/status/:${pkgs.adwaita-icon-theme}/share/icons/Adwaita/16x16/devices/";

            sticky_history = true;
            history_length = 20;

            dmenu = "/usr/bin/dmenu -p dunst:";
            browser = "/usr/bin/firefox -new-tab";
            always_run_script = true;
            title = "Dunst";
            class = "Dunst";
            corner_radius = 0;
            ignore_dbusclose = false;

            force_xwayland = false;
            force_xinerama = false;

            mouse_left_click = "close_current";
            mouse_middle_click = "do_action, close_current";
            mouse_right_click = "close_all";
          };

          experimental = {
            per_monitor_dpi = false;
          };

          urgency_low = {
            timeout = 10;
          };

          urgency_normal = {
            background = "#282828";
            foreground = "#8ec07c";
            timeout = 10;
          };

          urgency_critical = {
            background = "#282828";
            timeout = 0;
          };
        };
      };
    };
}
