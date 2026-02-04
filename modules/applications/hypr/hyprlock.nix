{ inputs, config, ... }:
{
  flake.homeModules.hyprlock =
    { lib, pkgs, ... }:
    {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = false;
            ignore_empty_input = false;
          };

          animations = {
            enabled = true;
            fade_in = {
              duration = 300;
              bezier = "easeOutQuint";
            };
            fade_out = {
              duration = 300;
              bezier = "easeOutQuint";
            };
          };

          background = [
            {
              monitor = "";

              path = "${../../../non-nix/wallpaper.jpg}";

              blur_passes = 2;
              contrast = 1;
              brightness = 0.5;
              vibrancy = 0.2;
              vibrancy_darkness = 0.2;

            }
          ];

          input-field = [
            {
              monitor = "";
              size = "250 60";
              outline_thickness = 2;
              dots_size = 0.2;
              dots_spacing = 0.35;
              dots_center = true;
              outer_color = "rgba(0, 0, 0, 0)";
              inner_color = "rgba(0, 0, 0, 0.2)";
              font_color = "rgb(202, 211, 245)";
              fade_on_empty = false;
              rounding = -1;
              check_color = "rgb(204, 136, 34)";
              placeholder_text = "<i><span foreground=\"##cdd6f4\">Input Password...</span></i>";
              hide_input = false;
              position = "0, -200";
              valign = "center";
              halign = "center";

            }

          ];

          label = [
            {
              monitor = "";
              # Use cmd to execute a command and display its output. The update interval is in ms.
              text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
              color = "rgba(242, 243, 244, 0.75)";
              font_size = 22;
              font_family = "Jetbrains Mono Medium";
              position = "0, 300";
              halign = "center";
              valign = "center";
            }
            {
              monitor = "";
              text = ''cmd[update:1000] echo "$(date +"%-I:%M")"'';
              color = "rgba(242, 243, 244, 0.75)";
              font_size = 95;
              font_family = "Jetbrains Mono Medium";
              position = "0, 200";
              halign = "center";
              valign = "center";

            }
            {

              monitor = "";
              text = ''cmd[update:1000] echo "$(whoami)"'';
              color = "rgb(202, 211, 245)";
              font_size = 14;
              font_family = "Jetbrains Mono Medium";
              position = "0, -10";
              halign = "center";
              valign = "top";
            }
            {
              monitor = "";
              # $LAYOUT is a hyprlock built-in variable
              text = "$LAYOUT";
              color = "rgb(202, 211, 245)"; # Replaced $foreground with a specific color
              font_size = 12;
              position = "0, 10";
              halign = "center";
              valign = "bottom";

            }
          ];

          image = [
            {
              monitor = "";
              path = "/home/justin/Pictures/profile_pictures/justin_square.png"; # <--- Ensure this path is correct
              size = 100;
              border_size = 2;
              border_color = "rgb(202, 211, 245)"; # Replaced $foreground with a specific color
              position = "0, -100";
              halign = "center";
              valign = "center";

            }
            {

              monitor = "";
              path = "/home/justin/Pictures/profile_pictures/hypr.png"; # <--- Ensure this path is correct
              size = 75;
              border_size = 2;
              border_color = "rgb(202, 211, 245)"; # Replaced $foreground with a specific color
              position = "-50, 50";
              halign = "right";
              valign = "bottom";
            }
          ];
        };
      };
    };
}
