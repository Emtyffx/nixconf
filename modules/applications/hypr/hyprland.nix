{ inputs, config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.homeModules.hyprland =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      monitorType = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Monitor identifier";
          };
          width = lib.mkOption {
            type = lib.types.int;
            default = 1920;
          };
          height = lib.mkOption {
            type = lib.types.int;
            default = 1080;
          };

          refreshRate = lib.mkOption {
            type = lib.types.int;
            default = 60;
          };

          x = lib.mkOption {
            type = lib.types.int;
            default = 0;

          };
          y = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };

          scale = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
          };

          transform = lib.mkOption {
            type = lib.types.enum [
              "normal"
              "90"
              "180"
              "270"
              "flipped"
              "flipped-90"
              "flipped-180"
              "flipped-270"
            ];
            default = "normal";
          };

          vrr = lib.mkOption {
            type = lib.types.ints.between 0 3;
            default = 0;
            description = "VRR mode: 0=off, 1=on, 2=fullscreen, 3=fullscreen+game";
          };

          hdr = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };

          primary = lib.mkOption {

            type = lib.types.bool;
            default = false;
          };

          enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
      hyprlandTransform =
        t:
        {
          "normal" = "0";
          "90" = "1";
          "180" = "2";
          "270" = "3";
          "flipped" = "4";
          "flipped-90" = "5";
          "flipped-180" = "6";
          "flipped-270" = "7";
        }
        .${t};

      toHyprland =
        mon:
        if mon.enabled then
          let
            base = "${mon.name},${toString mon.width}x${toString mon.height}@${toString mon.refreshRate},${toString mon.x}x${toString mon.y},${toString mon.scale}";
            transform = lib.optionalString (
              mon.transform != "normal"
            ) ",transform,${hyprlandTransform mon.transform}";
            vrr = lib.optionalString (mon.vrr > 0) ",vrr,${toString mon.vrr}";
            hdr = lib.optionalString mon.hdr ",bitdepth,10";
          in
          base + transform + vrr + hdr
        else
          "${mon.name},disable";

    in
    {

      options.hyprland = {
        isLaptop = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether the hyprland configuration is laptop or pc focused.";
        };
        monitors = lib.mkOption {
          type = lib.types.listOf monitorType;
          default = [ ];
          description = "Monitors list, default is empty.";
        };
      };
      config = {
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = true;
          plugins = [
            inputs.split-monitor-workspaces.packages.${pkgs.hostPlatform.system}.split-monitor-workspaces
          ];
          settings = {
            monitor = map toHyprland config.hyprland.monitors;

            "$mod" = "SUPER";
            "$terminal" = meta.defaults.terminal;
            "$fileManager" = meta.defaults.fileManager;
            "$browser" = meta.defaults.browser;

            exec-once = [
              "${pkgs.polkit_gnome}/bin/polkit-gnome-authentication-agent-1"
              "dunst"
              "${../../../non-nix/scripts/hyprland/autostart.sh}"

            ];

            exec = [
              "wl-paste --watch cliphist store"
              "swww-daemon"
              "pkill waybar; waybar"
              "swww img ${../../../non-nix/wallpaper.jpg} --transition-step 50 --transition-type center"
            ];

            input = {
              kb_layout = "us,ru,ua";

              kb_options = "grp:win_space_toggle";
            };

            general = {
              gaps_in = 5;
              gaps_out = 15;
              border_size = 2;
              "col.active_border" = "0xff8ec07c";
              "col.inactive_border" = "0xff928374";
              resize_on_border = (config.hyprland.isLaptop or false);

              allow_tearing = true;

              layout = "dwindle";
            };

            decoration = {
              rounding = 10;
              rounding_power = 2;
              active_opacity = 1.0;

              inactive_opacity = 0.9;
              fullscreen_opacity = 1.0;

              shadow = {
                enabled = true;
                range = 4;
                render_power = 3;
                color = "rgba(1a1a1aee)";

              };
              blur = {
                enabled = true;
                size = 2;
                passes = 2;
                vibrancy = 0.1696;
                ignore_opacity = true;
                new_optimizations = true;
                special = true;
                popups = true;
              };

            };

            # cursor = {
            #   no_hardware_cursor = true;
            #
            # };
            render = {
              direct_scanout = false;
            };

            misc = {
              vfr = true;
            };

            animations = {
              enabled = true;

              bezier = [
                "easeOutQuint, 0.23, 1, 0.32, 1"
                "easeInOutCubic, 0.65, 0.05, 0.36, 1"
                "linear, 0, 0, 1, 1"
                "almostLinear, 0.5, 0.5, 0.75, 1.0"
                "quick, 0.15, 0, 0.1, 1"
              ];

              animation = [
                "global, 1, 10, default"
                "border, 1, 5.39, easeOutQuint"
                "windows, 1, 4.79, easeOutQuint"
                "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
                "windowsOut, 1, 1.49, linear, popin 87%"
                "fadeIn, 1, 1.73, almostLinear"
                "fadeOut, 1, 1.46, almostLinear"
                "fade, 1, 3.03, quick"
                "layers, 1, 3.81, easeOutQuint"
                "workspaces, 1, 1.94, almostLinear, fade"
              ];
            };

            dwindle = {
              pseudotile = true;
              preserve_split = true;
            };

            xwayland = {
              force_zero_scaling = true;
            };

            windowrule = [
              "suppress_event maximize, match:class .*"
              "no_focus 1,match:class ^$,match:title ^$,match:xwayland 1,match:float 1,match:fullscreen 0,match:pin 0"
              "stay_focused 1,match:class zoom,match:title ^(menu window|Send chat to(\.\.\.|.*)?|Toolbar Menu)$"
              "float 1,match:title ^Qalculate!"
              "border_size 2, match:float 1"
              "no_blur 1, match:class zoom"
              "opacity 1.0 override 1.0 override, match:class ^(obs)$"
            ];
            workspace = [
              "w[tv1],  bordersize:0"
            ];

            bind = [

              "$mod, Return, exec, $terminal"
              "$mod, C, killactive,"
              "$mod, E, exec, $fileManager"
              "$mod, B, exec, $browser"
              "$mod, V, togglefloating,"
              "$mod, M, exec, wlogout"
              "$mod, R, exec, ${../../../non-nix/scripts/hyprland/rofi.sh} drun"
              "$mod, Q, exec, ${../../../non-nix/scripts/hyprland/rofi.sh} calc"
              "$mod SHIFT, R, exec, ${../../../non-nix/scripts/hyprland/rofi.sh} emoji"
              "$mod, P, pseudo,"
              "$mod, S, togglesplit,"
              "$mod, F, fullscreen,"
              "$mod SHIFT, L, exec, hyprlock"
              "$mod, Print, exec, ${../../../non-nix/scripts/hyprland/screenshot.sh} m"
              "$mod SHIFT, Print, exec, ${../../../non-nix/scripts/hyprland/screenshot.sh} sf"
              "$mod Ctrl, Print, exec, ${../../../non-nix/scripts/hyprland/screenshot.sh} p"
              "$mod, left, movefocus, l"
              "$mod, right, movefocus, r"
              "$mod, up, movefocus, u"
              "$mod, down, movefocus, d"
              "$mod, H, movefocus, l"
              "$mod, J, movefocus, d"
              "$mod, K, movefocus, u"
              "$mod, L, movefocus, r"
              "$mod, 1, split-workspace, 1"
              "$mod SHIFT, 1, split-movetoworkspacesilent, 1"
              "$mod, 2, split-workspace, 2"
              "$mod SHIFT, 2, split-movetoworkspacesilent, 2"
              "$mod, 3, split-workspace, 3"
              "$mod SHIFT, 3, split-movetoworkspacesilent, 3"
              "$mod, 4, split-workspace, 4"
              "$mod SHIFT, 4, split-movetoworkspacesilent, 4"
              "$mod, 5, split-workspace, 5"
              "$mod SHIFT, 5, split-movetoworkspacesilent, 5"
              "$mod, 6, split-workspace, 6"
              "$mod SHIFT, 6, split-movetoworkspacesilent, 6"
              "$mod, 7, split-workspace, 7"
              "$mod SHIFT, 7, split-movetoworkspacesilent, 7"
              "$mod, 8, split-workspace, 8"
              "$mod SHIFT, 8, split-movetoworkspacesilent, 8"
              "$mod, 9, split-workspace, 9"
              "$mod SHIFT, 9, split-movetoworkspacesilent, 9"
              "$mod, 0, split-workspace, 10"
              "$mod SHIFT, 0, split-movetoworkspacesilent, 10"
              "$mod, minus, togglespecialworkspace, magic"
              "$mod SHIFT, minus, movetoworkspace, special:magic"
              "$mod SHIFT, V, exec, ${../../../non-nix/scripts/hyprland/rofi.sh} clipboard"
              "ALT, R, submap, resize"

            ];
            bindm = [
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];

            binde = [

              "$mod SHIFT, up, exec, ${../../../non-nix/scripts/hyprland/brightness.sh} inc"
              "$mod SHIFT, down, exec, ${../../../non-nix/scripts/hyprland/brightness.sh} dec"
            ];
            bindel = [
              ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
              ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
              ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
            ];

          };
          submaps = {
            resize = {
              settings = {
                bind = [ ", escape, submap, reset" ];
                binde = [

                  ", right, resizeactive, 10 0"
                  ", left, resizeactive, -10 0"
                  ", up, resizeactive, 0 -10"
                  ", down, resizeactive, 0 10"
                ];
              };
            };
          };
        };
      };
    };
}
