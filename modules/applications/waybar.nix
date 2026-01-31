{ inputs, config, ... }:
{
  flake.homeModules.waybar =
    { lib, pkgs, ... }:
    {
      programs.waybar = {
        enable = true;
        settings = [
          {
            position = "top";
            output = [
              "!grimblastVD"
              "DP-1"
              "DP-2"
            ];
            height = 29;
            modules-left = [
              "hyprland/workspaces"
              "hyprland/submap"
            ];
            modules-center = [
              "idle_inhibitor"
              "clock"
            ];
            modules-right = [
              "pulseaudio"
              "network"
              "bluetooth"
              "memory"
              "cpu"
              "custom/ddcutil"
              "hyprland/language"
              "tray"
              "custom/power"
            ];
            "custom/ddcutil" = {
              format = " {percentage}%";
              interval = 1;
              format-icons = [
                ""
              ];
              exec = "~/.config/hypr/scripts/brightness.sh";
              return-type = "json";
            };
            "hyprland/workspaces" = {
              format = "{icon}";
              format-icons = {
                active = "";
                default = "";
              };
              all-outputs = false;
              persistent-workspaces = {
                DP-1 = [
                  1
                  2
                  3
                  4
                  5
                ];
                DP-2 = [
                  11
                  12
                  13
                  14
                  15
                ];
              };
            };
            "hyprland/window" = {
              format = "{initialTitle}";
            };
            clock = {
              format = "{:%H:%M}";
              format-alt = "{:%A, %B %d, %Y (%R)}  ";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "year";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                format = {
                  months = "<span color='#ffead3'><b>{}</b></span>";
                  days = "<span color='#ecc6d9'><b>{}</b></span>";
                  weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                  weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                  today = "<span color='#ff6699'><b><u>{}</u></b></span>";
                };
              };
              actions = {
                on-click-right = "mode";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };
            network = {
              format-wifi = "󰤨 {essid}";
              format-ethernet = "󱘖 Wired";
              format-linked = "󱘖 {ifname} (No IP)";
              format-disconnected = "󰤮 Off";
              format-alt = "󰤨 {signalStrength}%";
              tooltip-format = "󱘖 {ipaddr}   {bandwidthUpBytes}    {bandwidthDownBytes}";
            };
            pulseaudio = {
              format = "{icon} {volume}%";
              format-muted = " ";
              scroll-step = 4;
              format-icons = {
                headphone = "";
                phone = "";
                phone-muted = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                  ""
                ];
              };
              format-bluetooth = " {volume}% via ";
              on-click = "pavucontrol -t 3";
            };
            cpu = {
              interval = 2;
              format = " {icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9} {usage:>2}%";
              format-icons = [
                "▁"
                "▂"
                "▃"
                "▄"
                "▅"
                "▆"
                "▇"
                "█"
              ];
            };
            memory = {
              interval = 30;
              format = " {}%";
              max-length = 10;
            };
            bluetooth = {
              format = "";
              format-connected = " {num_connections}";
              tooltip-format = " {device_alias}";
              tooltip-format-connected = "{device_enumerate}";
              tooltip-format-enumerate-connected = " {device_alias}";
              on-click = "blueman-manager";
            };
            "custom/power" = {
              format = "{}";
              on-click = "wlogout -b 6";
              interval = 86400;
              tooltip = true;
            };
            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "󰥔";
                deactivated = "";
              };
            };
            cava = {
              hide_on_silence = false;
              framerate = 60;
              bars = 10;
              format-icons = [
                "▁"
                "▂"
                "▃"
                "▄"
                "▅"
                "▆"
                "▇"
                "█"
              ];
              input_delay = 1;
              sleep_timer = 5;
              bar_delimiter = 0;
            };
            tray = {
              icon-size = 12;
              spacing = 5;
            };
            "hyprland/language" = {
              format = "{short} {variant}";
              on-click = "${../../non-nix/scripts/hyprland/keyboardswitch.sh}";
            };
            "hyprland/submap" = {
              format = "{}";
              default-submap = "default";
              tooltip = false;
            };
          }
        ];

        style = ../../non-nix/waybar_style.css;
      };
    };
}
