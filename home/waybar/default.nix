{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "custom/logo"
          "hyprland/workspaces"
          "sway/mode"
        ];
        modules-right = [
          "tray"
          # "sway/language"
          "network"
          "wireplumber"
          "clock"
          # "battery"
          "custom/power"
        ];
        "hyprland/workspaces" = {
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
          };
        };
        "custom/logo" = {
          format = "";
          tooltip = false;
          on-click = "wofi --show drun";
        };
        "sway/mode" = {
          tooltip = false;
        };
        "tray" = {
          icon-size = 21;
          spacing = 15;
        };
        "clock" = {
          interval = 60;
          format = "{:%a %d/%m %I:%M}";
        };
        "network" = {
          format = "{icon}";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];

          format-ethernet = "󰀂";
          format-alt = "󱛇";

          tooltip-format-wifi = "{icon} {essid}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "󰀂  {ifname}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 5;
          nospacing = 1;

        };
        "wireplumber" = {
          format-bluetooth = "󰂰";
          tooltip-format = "Volume : {volume}%";
          format-muted = "󰝟";
          format-icons = {
            headphone = "";
            default = [
              "󰖀"
              "󰕾"
              ""
            ];
          };
          on-click = "pamixer -t";
          scroll-step = 1;
        };
        "mpd" = {
          format = "{stateIcon} {artist} - {title}";
          format-disconnected = "🎶";
          format-stopped = "♪";
          interval = 10;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          max-length = 45;
        };
        "custom/power" = {
          format = "⏻";
          on-click = "wlogout";
        };

        "battery" = {
          tooltip = false;

        };
      };
    };
    style = ./style.css;
  };
}
