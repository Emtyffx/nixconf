{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;

        modules-left = [
          "custom/logo"
          "sway/workspaces"
          "sway/mode"
        ];
        modules-right = [
          "tray"
          "sway/language"
          "clock"
          "battery"
        ];
        "sway/workspaces" = {
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
        "sway/language" = {
          format = "{shortDescription}";
          tooltip = false;
          on-click = "swaymsg input \"*\" xkb_switch_layout next";
        };
        "clock" = {
          interval = 60;
          format = "{:%a %d/%m %I:%M}";
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
         font-size: 22px;
       }

       window#waybar {
         background: #292828;
         color: #ffffff;
       }

       #custom-logo {
         font-size: 32px;
         margin: 0;
         margin-left: 14px;
         margin-right: 36px;
         padding: 0;
         font-family: NotoSans Nerd Font Mono;
       }

       #workspaces button {
         margin-right: 0;
         padding-left: 15px;
         padding-right: 15px;
         padding-top: 10px;
         padding-bottom: 10px;
         color: #ffffff;
       }
       #workspaces button:hover, #workspaces button:active {
         background-color: #292828;
         color: #ffffff;
       }
       #workspaces button.focused {
         background-color: #383737;
       }
       
       #tray {
         margin-right: 14px;
       }
       #language {
         margin-right: 14px;		
       }

       #battery {
         margin-left: 14px;
         margin-right: 6px;
       }
    '';
  };
}
