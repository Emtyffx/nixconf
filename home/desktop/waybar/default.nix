{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = lib.mkAfter (
    with pkgs;
    [
      pamixer
      pavucontrol
    ]
  );
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    settings = [
      {
        position = "top";
        output = [
          "!grimblastVD"
          "*"
        ];
        height = 29;

        "modules-left" = [
          "hyprland/workspaces"
          "cava"
        ];
        "modules-center" = [
          "idle_inhibitor"
          "clock"
        ];
        "modules-right" = [
          "pulseaudio"
          "network"
          "bluetooth"
          "memory"
          "cpu"
          "hyprland/language"
          "tray"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          "format-icons" = {
            active = "";
            default = "";
          };
          "persistent-workspaces" = {
            "*" = [
              1
              2
              3
              4
              5
            ];
          };
        };

        "hyprland/window" = {
          format = "    {initialTitle}";
        };

        clock = {
          format = "{:%H:%M}";
          "format-alt" = "{:%A, %B %d, %Y (%R)}  ";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            "on-click-right" = "mode";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };

        network = {
          "format-wifi" = "󰤨 {essid}";
          "format-ethernet" = "󱘖 Wired";
          "format-linked" = "󱘖 {ifname} (No IP)";
          "format-disconnected" = "󰤮 Off";
          "format-alt" = "󰤨 {signalStrength}%";
          "tooltip-format" = "󱘖  {ipaddr}     {bandwidthUpBytes}     {bandwidthDownBytes}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          "format-muted" = " ";
          "scroll-step" = 4;
          "format-icons" = {
            headphone = "";
            phone = "";
            "phone-muted" = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          "format-bluetooth" = "  {volume}% via ";
        };

        cpu = {
          interval = 1;
          format = "  {icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9} {usage:>2}%";
          "format-icons" = [
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
          "max-length" = 10;
        };

        bluetooth = {
          format = "";
          "format-connected" = " {num_connections}";
          "tooltip-format" = " {device_alias}";
          "tooltip-format-connected" = "{device_enumerate}";
          "tooltip-format-enumerate-connected" = " {device_alias}";
          "on-click" = "blueman-manager";
        };

        "custom/power" = {
          format = "{}";
          "on-click" = "wlogout -b 6";
          interval = 86400;
          tooltip = true;
        };

        idle_inhibitor = {
          format = "{icon}";
          "format-icons" = {
            activated = "󰥔";
            deactivated = "";
          };
        };

        cava = {
          hide_on_silence = false;
          framerate = 60;
          bars = 10;
          "format-icons" = [
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
          "icon-size" = 12;
          spacing = 5;
        };

        "hyprland/language" = {
          format = "{short} {variant}";
          "on-click" = "\${./scripts/keyboardswitch.sh}";
        };
      }
    ];
    style = ''
      /* === Color Definitions === */

      /* Warm colors */
      @define-color flamingo #e69875;
      @define-color peach    #e69875;
      @define-color red      #e67e80;
      @define-color maroon   #e67e80;
      @define-color yellow   #dbbc7f;
      @define-color pink     #d699b6;

      /* Cool colors */
      @define-color green    #a7c080;
      @define-color teal     #83c092;
      @define-color sky      #7fbbb3;
      @define-color sapphire #7fbbb3;
      @define-color blue     #7fbbb3;

      /* Neutral colors */
      @define-color lavender  #d3c6aa;
      @define-color text      #d3c6aa;
      @define-color subtext1  #859289;
      @define-color subtext0  #7a8478;
      @define-color overlay2  #495156;
      @define-color overlay1  #414b50;
      @define-color overlay0  #374145;
      @define-color surface2  #2e383c;
      @define-color surface1  #272e33;
      @define-color surface0  #22282c;
      @define-color base      #272e33;
      @define-color mantle    #22282c;
      @define-color crust     #1e2326;


      /* === Waybar Root === */

      window#waybar {
        background: none;
        color: @text;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
      }


      /* === Module Containers === */

      .modules-center,
      .modules-right,
      #window,
      #workspaces,
      #cava {
        background: @base;
        padding: 0px 10px;
        margin-top: 10px;
        margin-left: 15px;
        margin-right: 15px;
        border-radius: 7px;
        border: 1px solid @overlay2;
      }

      .modules-right {
        padding: 10px 15px;
      }

      #workspaces {
        margin-right: 10px;
        padding-right: 15px;
      }

      #cava {
        margin-left: 0;
        color: @pink;
      }


      /* === Widgets === */

      #clock {
        padding: 0px 10px;
        color: @yellow;
      }

      #workspaces button {
        padding: 7px;
        color: @text;
      }

      #workspaces button:not(.active):hover {
        color: @subtext0;
        background: none;
        transition-duration: 0.1s;
      }

      #workspaces button.active:hover {
        background: none;
      }

      #network {
        color: @flamingo;
        /* padding: 0px 10px; */
      }

      #pulseaudio {
        color: @red;
      }

      #cpu {
        color: @blue;
      }

      #memory {
        color: @green;
      }

      #bluetooth {
        color: @sapphire;
      }

      #custom-power {
        color: @red;
      }

      #idle_inhibitor {
        color: @sky;
      }


      /* === Universal Padding for Right Modules === */

      #network,
      #pulseaudio,
      #cpu,
      #memory,
      #bluetooth,
      #idle_inhibitor,
      #custom-power,
      #tray,
      #language {
        padding: 0 5px;
      }


      /* === Tooltip === */

      tooltip {
        background: #1e1e2e;
        border-radius: 8px;
      }

      tooltip label {
        color: #cad3f5;
        margin-right: 5px;
        margin-left: 5px;
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
