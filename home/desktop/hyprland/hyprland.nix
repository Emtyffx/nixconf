{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  convertColor =
    colorString:
    let
      # Use builtins.substring to remove the leading '#' from the string.
      rgbPart = builtins.substring 1 (builtins.stringLength colorString - 1) colorString;
    in
    # Concatenate the '0xff' prefix with the extracted RGB part.
    "0xff${rgbPart}";

in
{
  options.myHyprland = {
    enable = lib.mkEnableOption "Enable custom hyprland config";
    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Path to the current theme wallpaper";
    };
  };
  config = lib.mkIf config.myHyprland.enable {
    home.packages = lib.mkAfter (
      with pkgs;
      [
        swappy
        grimblast
      ]
    );
    wayland.windowManager.hyprland = {
      plugins = [
        inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = null;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "kitty";
        "$fileManager" = "nautilus";
        "$menu" = "wofi --show drun";
        "$browser" = "app.zen_browser.zen";

        monitor = [
          "DP-4,preferred,0x0,1.25"
          "DP-5,preferred,-3072x0,1.25"
        ];
        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,Adwaita"
        ];
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = convertColor config.myWaybar.colors.main_color;
          "col.inactive_border" = convertColor config.myWaybar.colors.mantle;
          resize_on_border = false;
          allow_tearing = true;
          layout = "dwindle";
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        exec-once = [
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "hyprctl setcursor Adwaita 24"
          "dunst"
          "${./scripts/autostart.sh}"
        ];
        exec = [
          "pkill waybar; waybar"
          "swww img ${config.myHyprland.wallpaper} --transition-step 50 --transition-type center"
        ];
        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1;
          inactive_opacity = 0.9;
          fullscreen_opacity = 1.0;
          shadow = {
            enabled = "true";
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = "true";
            size = 2;
            passes = 2;
            vibrancy = 0.1696;
            ignore_opacity = true;
            new_optimizations = true;
            special = true;
            popups = true;

          };
        };
        input = {
          kb_layout = "us,ru,ua";
          kb_options = "grp:win_space_toggle";
        };
        animations = {
          enabled = "yes, please :)";
          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
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
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        bind = [
          "$mod, Return, exec, $terminal"
          "$mod, C, killactive,"
          "$mod, E, exec, $fileManager"
          "$mod, B, exec, $browser"
          "$mod, V, togglefloating,"
          "$mod, M, exec, wlogout &"
          "$mod, R, exec, ${./scripts/rofi.sh} drun"
          "$mod, Q, exec, ${./scripts/rofi.sh} calc"
          "$mod SHIFT, R, exec, ${./scripts/rofi.sh} emoji"
          "$mod, P, pseudo,"
          "$mod, S, togglesplit,"
          "$mod, F, fullscreen,"
          "$mod SHIFT, L, exec, hyprlock"
        ]
        # screenshot
        ++ [
          "$mod, Print, exec, ${./scripts/screenshot.sh} m"
          "$mod SHIFT, Print, exec, ${./scripts/screenshot.sh} sf"
          "$mod Ctrl, Print, exec, ${./scripts/screenshot.sh} p"
        ]
        # vim-like movement
        ++ [
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"
        ]
        # workspaces
        ++ builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, split-workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, split-movetoworkspacesilent, ${toString ws}"
            ]
          ) 9
        )
        ++ [
          "$mod, 0, split-workspace, 10"
          "$mod SHIFT, 0, split-movetoworkspacesilent, 10"
        ]
        # scratchpad
        ++ [
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"
        ]
        # scrolling
        ++ [
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
        ]
        # submaps
        ++ [
          "ALT, R, submap, resize"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];
        windowrule = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          "stayfocused,class:zoom,title:^(menu window|Send chat to(\.\.\.|.*)?)$"
          "float,title:^Qalculate!"
          "opacity 0.0 override, class:^(xwaylandvideobridge)$"
          "noanim, class:^(xwaylandvideobridge)$"
          "noinitialfocus, class:^(xwaylandvideobridge)$"
          "maxsize 1 1, class:^(xwaylandvideobridge)$"
          "noblur, class:^(xwaylandvideobridge)$"
          "nofocus, class:^(xwaylandvideobridge)$"
        ];
        windowrulev2 = [
          "bordersize 2, floating:1"
          "noblur, class:zoom"
        ];
        xwayland = {
          force_zero_scaling = "true";
        };
        workspace = [
          "w[tv1], bordersize:0"

        ];

        plugin = {
          split-monitor-workspaces = {
            count = 10;
            keep_focused = 0;
            enable_notifications = 0;
            enable_persistent_workspaces = 1;
          };
        };
        # submaps
      };
      submaps = {
        resize = {
          settings = {
            binde = [
              ", right, resizeactive, 10 0"
              ", left, resizeactive, -10 0"
              ", up, resizeactive, 0 -10"
              ", down, resizeactive, 0 10"
            ];
            bind = [
              ", escape, submap, reset"
            ];
          };
        };
      };
    };
  };
}
