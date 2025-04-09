{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    settings = [
      {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        ipc = true;
        fixed-center = true;
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;
        margin-bottom = 0;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        # modules-center = ["clock" "custom/notification"];
        modules-center = [
          "idle_inhibitor"
          "clock"
          "cava"
        ];
        modules-right = [
          # "custom/gpuinfo"
          "cpu"
          "memory"
          "pulseaudio"
          "backlight"
          "network"
          "hyprland/language"
          "bluetooth"
          "tray"
          "battery"
          "custom/power"
        ];

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/colour-temperature" = {
          format = "{} ";
          exec = "wl-gammarelay-rs watch {t}";
          on-scroll-up = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100";
          on-scroll-down = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100";
        };
        "custom/cava_mviz" = {
          exec = "${./scripts/WaybarCava.sh}";
          format = "{}";
        };
        "cava" = {
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
          # "noise_reduction" = 0.77;
          sleep_timer = 5;
          bar_delimiter = 0;
        };
        # "custom/gpuinfo" = {
        #   exec = "${../../scripts/gpuinfo.sh}";
        #   return-type = "json";
        #   format = " {}";
        #   interval = 5; # once every 5 seconds
        #   tooltip = true;
        #   max-length = 1000;
        # };
        "custom/icon" = {
          # format = " ";
          exec = "echo ' '";
          format = "{}";
        };
        "mpris" = {
          format = "{player_icon} {title} - {artist}";
          format-paused = "{status_icon} <i>{title} - {artist}</i>";
          player-icons = {
            default = "▶";
            spotify = "";
            mpv = "󰐹";
            vlc = "󰕼";
            firefox = "";
            chromium = "";
            kdeconnect = "";
            mopidy = "";
          };
          status-icons = {
            paused = "⏸";
            playing = "";
          };
          ignored-players = [
            "firefox"
            "chromium"
          ];
          max-length = 30;
        };
        "temperature" = {
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
          critical-threshold = 83;
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
          ];
          interval = 10;
        };
        "hyprland/language" = {
          format = "{short}"; # can use {short} and {variant}
          on-click = "${./scripts/keyboardswitch.sh}";
        };
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          active-only = false;
          on-click = "activate";
          persistent-workspaces = {
            "*" = [
              1
              2
              3
              4
              5
              6
              7
              8
              9
              10
            ];
          };
        };

        "hyprland/window" = {
          format = "  {}";
          separate-outputs = true;
          rewrite = {
            "harvey@hyprland =(.*)" = "$1 ";
            "(.*) — Mozilla Firefox" = "$1 󰈹";
            "(.*)Mozilla Firefox" = " Firefox 󰈹";
            "(.*) - Visual Studio Code" = "$1 󰨞";
            "(.*)Visual Studio Code" = "Code 󰨞";
            "(.*) — Dolphin" = "$1 󰉋";
            "(.*)Spotify" = "Spotify 󰓇";
            "(.*)Spotify Premium" = "Spotify 󰓇";
            "(.*)Steam" = "Steam 󰓓";
          };
          max-length = 1000;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰥔";
            deactivated = "";
          };
        };

        "clock" = {
          format = "{:%a %d %b %R}";
          # format = "{:%R 󰃭 %d·%m·%y}";
          format-alt = "{:%I:%M %p}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "cpu" = {
          interval = 10;
          format = "󰍛 {usage}%";
          format-alt = "{icon0}{icon1}{icon2}{icon3}";
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

        "memory" = {
          interval = 30;
          format = "󰾆 {percentage}%";
          format-alt = "󰾅 {used}GB";
          max-length = 10;
          tooltip = true;
          tooltip-format = " {used =0.1f}GB/{total =0.1f}GB";
        };

        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 2%+";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
        };

        "network" = {
          # on-click = "nm-connection-editor";
          # "interface" = "wlp2*"; # (Optional) To force the use of this interface
          format-wifi = "󰤨 Wi-Fi";
          # format-wifi = "󰤨 {essid}";
          format-ethernet = "󱘖 Wired";
          format-linked = "󱘖 {ifname} (No IP)";
          format-disconnected = "󰤮 Off";
          # format-disconnected = "󰤮 Disconnected";
          format-alt = "󰤨 {signalStrength}%";
          tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
        };

        "bluetooth" = {
          format = "";
          # format-disabled = ""; # an empty format will hide the module
          format-connected = " {num_connections}";
          tooltip-format = " {device_alias}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = " {device_alias}";
          on-click = "blueman-manager";
        };

        "pulseaudio" = {
          format = "{icon} {volume}";
          format-muted = " ";
          on-click = "pavucontrol -t 3";
          tooltip-format = "{icon} {desc} // {volume}%";
          scroll-step = 4;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
        };

        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          on-click = "pavucontrol -t 4";
          tooltip-format = "{format_source} {source_desc} // {source_volume}%";
          scroll-step = 5;
        };

        "tray" = {
          icon-size = 12;
          spacing = 5;
        };

        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          # format-charging = " {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        "custom/power" = {
          format = "{}";
          on-click = "wlogout -b 6";
          interval = 86400; # once every day
          tooltip = true;
        };
      }
    ];
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        margin: 0px;
        padding: 0px;
      }

      @define-color base   #1e2326;
      @define-color mantle #181b1f;
      @define-color crust  #141617;

      @define-color text     #d3c6aa;
      @define-color subtext0 #a7c080;
      @define-color subtext1 #e69875;

      @define-color surface0 #2e383c;
      @define-color surface1 #3a454a;
      @define-color surface2 #475257;

      @define-color overlay0 #6c7a79;
      @define-color overlay1 #859289;
      @define-color overlay2 #9da9a0;

      @define-color blue      #7fbbb3;
      @define-color lavender  #a7c080;
      @define-color sapphire  #83c092;
      @define-color sky       #9da9a0;
      @define-color teal      #7fbbb3;
      @define-color green     #a7c080;
      @define-color yellow    #dbbc7f;
      @define-color peach     #e69875;
      @define-color maroon    #e67e80;
      @define-color red       #e67e80;
      @define-color mauve     #d699b6;
      @define-color pink      #e69875;
      @define-color flamingo  #e69875;
      @define-color rosewater #f4e8d6;

      window#waybar {
        transition-property: background-color;
        transition-duration: 0.5s;
        background: transparent;
        /*border: 2px solid @overlay0;*/
        /*background: @theme_base_color;*/
        border-radius: 10px;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      tooltip {
        background: #1e1e2e;
        border-radius: 8px;
      }

      tooltip label {
        color: #cad3f5;
        margin-right: 5px;
        margin-left: 5px;
      }

      /* This section can be use if you want to separate waybar modules */
      .modules-left {
      	background: @theme_base_color;
       	border: 1px solid @blue;
      	padding-right: 15px;
      	padding-left: 2px;
      	border-radius: 10px;
      }
      .modules-center {
      	background: @theme_base_color;
        border: 0.5px solid @overlay0;
      	padding-right: 5px;
      	padding-left: 5px;
      	border-radius: 10px;
      }
      .modules-right {
      	background: @theme_base_color;
       	border: 1px solid @blue;
      	padding-right: 15px;
      	padding-left: 15px;
      	border-radius: 10px;
      }

      #backlight,
      #backlight-slider,
      #battery,
      #bluetooth,
      #clock,
      #cpu,
      #disk,
      #idle_inhibitor,
      #keyboard-state,
      #memory,
      #mode,
      #mpris,
      #network,
      #pulseaudio,
      #pulseaudio-slider,
      #taskbar button,
      #taskbar,
      #temperature,
      #tray,
      #window,
      #wireplumber,
      #workspaces,
      #custom-backlight,
      #custom-cycle_wall,
      #custom-keybinds,
      #custom-keyboard,
      #custom-light_dark,
      #custom-lock,
      #custom-menu,
      #custom-power_vertical,
      #custom-power,
      #custom-swaync,
      #custom-updater,
      #custom-weather,
      #custom-weather.clearNight,
      #custom-weather.cloudyFoggyDay,
      #custom-weather.cloudyFoggyNight,
      #custom-weather.default,
      #custom-weather.rainyDay,
      #custom-weather.rainyNight,
      #custom-weather.severe,
      #custom-weather.showyIcyDay,
      #custom-weather.snowyIcyNight,
      #custom-weather.sunnyDay {
      	padding-top: 3px;
      	padding-bottom: 3px;
      	padding-right: 6px;
      	padding-left: 6px;
      }

      #idle_inhibitor {
        color: @blue;
      }

      #bluetooth,
      #backlight {
        color: @blue;
      }

      #battery {
        color: @green;
      }

      @keyframes blink {
        to {
          color: @surface0;
        }
      }

      #battery.critical:not(.charging) {
        background-color: @red;
        color: @theme_text_color;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        box-shadow: inset 0 -3px transparent;
      }

      #custom-updates {
        color: @blue
      }

      #custom-notification {
        color: #dfdfdf;
        padding: 0px 5px;
        border-radius: 5px;
      }

      #language {
        color: @blue
      }

      #clock {
        color: @yellow;
      }

      #custom-icon {
        font-size: 15px;
        color: #cba6f7;
      }

      #custom-gpuinfo {
        color: @maroon;
      }

      #cpu {
        color: @yellow;
      }

      #custom-keyboard,
      #memory {
        color: @green;
      }

      #disk {
        color: @sapphire;
      }

      #temperature {
        color: @teal;
      }

      #temperature.critical {
        background-color: @red;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      #keyboard-state {
        color: @flamingo;
      }

      #workspaces button {
          box-shadow: none;
      	text-shadow: none;
          padding: 0px;
          border-radius: 9px;
          padding-left: 4px;
          padding-right: 4px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #workspaces button:hover {
      	border-radius: 10px;
      	color: @overlay0;
      	background-color: @surface0;
       	padding-left: 2px;
          padding-right: 2px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #workspaces button.persistent {
      	color: @surface1;
      	border-radius: 10px;
      }

      #workspaces button.active {
      	color: @peach;
        	border-radius: 10px;
          padding-left: 8px;
          padding-right: 8px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #workspaces button.urgent {
      	color: @red;
       	border-radius: 0px;
      }

      #taskbar button.active {
          padding-left: 8px;
          padding-right: 8px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #taskbar button:hover {
          padding-left: 2px;
          padding-right: 2px;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #custom-cava_mviz {
      	color: @pink;
      }

      #cava {
      	color: @pink;
      }

      #mpris {
      	color: @pink;
      }

      #custom-menu {
        color: @rosewater;
      }

      #custom-power {
        color: @red;
      }

      #custom-updater {
        color: @red;
      }

      #custom-light_dark {
        color: @blue;
      }

      #custom-weather {
        color: @lavender;
      }

      #custom-lock {
        color: @maroon;
      }

      #pulseaudio {
        color: @lavender;
      }

      #pulseaudio.bluetooth {
        color: @pink;
      }
      #pulseaudio.muted {
        color: @red;
      }

      #window {
        color: @mauve;
      }

      #custom-waybar-mpris {
        color:@lavender;
      }

      #network {
        color: @blue;
      }
      #network.disconnected,
      #network.disabled {
        background-color: @surface0;
        color: @text;
      }
      #pulseaudio-slider slider {
      	min-width: 0px;
      	min-height: 0px;
      	opacity: 0;
      	background-image: none;
      	border: none;
      	box-shadow: none;
      }

      #pulseaudio-slider trough {
      	min-width: 80px;
      	min-height: 5px;
      	border-radius: 5px;
      }

      #pulseaudio-slider highlight {
      	min-height: 10px;
      	border-radius: 5px;
      }

      #backlight-slider slider {
      	min-width: 0px;
      	min-height: 0px;
      	opacity: 0;
      	background-image: none;
      	border: none;
      	box-shadow: none;
      }

      #backlight-slider trough {
      	min-width: 80px;
      	min-height: 10px;
      	border-radius: 5px;
      }

      #backlight-slider highlight {
      	min-width: 10px;
      	border-radius: 5px;
      }
    '';
  };
  programs.cava = {
    enable = true;
    settings = {
      general = {
        framerate = 60;
        sensitivity = 100; # Default
        autosens = 1;
      };
      color = {
        gradient = 1;

        # Mocha
        gradient_color_1 = "'#94e2d5'";
        gradient_color_2 = "'#89dceb'";
        gradient_color_3 = "'#74c7ec'";
        gradient_color_4 = "'#89b4fa'";
        gradient_color_5 = "'#cba6f7'";
        gradient_color_6 = "'#f5c2e7'";
        gradient_color_7 = "'#eba0ac'";
        gradient_color_8 = "'#f38ba8'";
      };
    };
  };
}
