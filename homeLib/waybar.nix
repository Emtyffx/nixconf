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

        "battery" = {
          tooltip = false;

        };
      };
    };
    style = ''
            * {
               border: none;
               border-radius: 0;
               padding: 0;
               margin: 0;
               font-size: 18px;
               font-family: Source Code Pro Medium;
             }

             window#waybar {
               color: #ffffff;
               background: rgba(0,0,0,0);
             }

             #custom-logo {
               font-size:  28px;
               margin-left: 14px;
               margin-right: 20px;
               font-family: Source Code Pro;
             }

             #workspaces button {
               margin: 5px;
               padding: 10px 20px;
               background-color: rgba(63,61,61,0.65);
               border-radius: 10px;
               color: #ffffff;
             }
             #workspaces button.active {

             }
             #workspaces button:hover {
               background-color: #545353;
               color: #ffffff;
             }
             #workspaces button.focused {
               background-color: #383737;
             }
             #workspaces button.active {
               background-color: rgba(197, 224, 161, 1);
               color: #333333;
             }
             #workspaces button.urgent {
               background-color:  #d1cc92;
               color: #333333;
             }
             
             #tray {
               margin-right: 14px;
             }
             #language {
               margin-right: 14px;		
             }
             #clock  {
               margin-left: 10px;
             }


             #battery {
               margin-left: 14px;
               margin-right: 6px;
             }
             #network ,
             #clock,
             #tray, #wireplumber
      {
               padding: 10px 15px;
               margin: 5px;
               background-color: rgba(63,61,61,0.65);
               border-radius: 10px;
               border: 1px solid #9e9a9b;
             }

             #network {
               padding-right: 19.5px;
             }
    '';
  };
}
