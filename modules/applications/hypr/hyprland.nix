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
      wallpaper = meta.defaults.theme.wallpaper;
      colors = meta.defaults.theme.colors;
      accent = meta.defaults.theme.gtk-theme-args.accent;
      toHyprlandCol = col: "rgb(${lib.toLower (lib.removePrefix "#" col)})";
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
          {
            output = mon.name;
            mode = "${toString mon.width}x${toString mon.height}@${toString mon.refreshRate}";
            position = "${toString mon.x}x${toString mon.y}";
            scale = mon.scale;
          }
          // lib.optionalAttrs (mon.transform != "normal") {
            transform = hyprlandTransform mon.transform;
          }
          // lib.optionalAttrs (mon.vrr > 0) {
            vrr = mon.vrr;
          }
          // lib.optionalAttrs mon.hdr {
            bitdepth = 10;
          }
        else
          {
            output = mon.name;
            enabled = false;
          };

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
        systemd.user.services.polkit-gnome-authentication-agent-1 = {
          Unit = {
            Description = "polkit-gnome-authentication-agent-1";
            Wants = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = true;
          # plugins = [
          #   inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
          # ];
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;

          # configType = "hyprlang";
          settings =

            let
              lua = lib.generators.mkLuaInline;
              execFunc =
                cmds:
                lua ''
                  function()
                  ${builtins.concatStringsSep "\n" (map (cmd: "  hl.exec_cmd(\"${cmd}\")") cmds)}
                  end
                '';
              dsp = {
                exec = cmd: lua "hl.dsp.exec_cmd(\"${cmd}\")";
                close = lua "hl.dsp.window.close()";
                fullscreen = lua "hl.dsp.window.fullscreen()";
                float = lua "hl.dsp.window.float()";
                pseudo = lua "hl.dsp.window.pseudo()";
                movefocus = dir: lua "hl.dsp.focus({ direction = \"${dir}\" })";
                workspace = ws: lua "smw.workspace(\"${toString ws}\")";
                mvworkspace = ws: lua "smw.move_to_workspace_silent(\"${toString ws}\")";
                specialworkspace = lua "hl.dsp.workspace.toggle_special(\"magic\")";
                mvspecialworkspace = lua "hl.dsp.window.move({ workspace = \"special:magic\" })";
                submap = name: lua "hl.dsp.submap(\"${name}\")";
                drag = lua "hl.dsp.window.drag()";
                resize = lua "hl.dsp.window.resize()";
              };

              bind = keys: dsp: {
                _args = [
                  keys
                  dsp
                ];
              };
              bindm = keys: dsp: {
                _args = [
                  keys
                  dsp
                  { mouse = true; }
                ];
              };

              binde = keys: dsp: {
                _args = [
                  keys
                  dsp
                  { repeating = true; }
                ];
              };

              bindel = keys: dsp: {
                _args = [
                  keys
                  dsp
                  {
                    repeating = true;
                    locked = true;
                  }
                ];

              };
              modVar = "SUPER";
              terminalVar = meta.defaults.terminal;
              fileManagerVar = meta.defaults.fileManager;
              browserVar = meta.defaults.browser;

            in
            {
              smw = {
                _var = lib.generators.mkLuaInline "require(\"split-monitor-workspaces\")";
              };
              monitor = map toHyprland config.hyprland.monitors;

              on = {
                _args = [
                  "hyprland.start"
                  (execFunc [
                    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                    # "${pkgs.polkit_gnome}/bin/polkit-gnome-authentication-agent-1"
                    "awww-daemon"
                    "dunst"
                    "awww img ${wallpaper} --transition-step 50 --transition-type center"
                    "${../../../non-nix/scripts/hyprland/autostart.sh}"
                    "wl-paste --watch cliphist store"
                    "waybar"

                  ])
                ];
              };

              config = {
                input = {
                  kb_layout = "us,ru,ua";

                  kb_options = "grp:win_space_toggle";
                };

                general = {
                  gaps_in = 5;
                  gaps_out = 15;
                  border_size = 2;
                  col.active_border = toHyprlandCol accent;
                  col.inactive_border = toHyprlandCol colors.gray;
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

                # misc = {
                #   vfr = true;
                # };

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
                  # pseudotile = true;
                  preserve_split = true;
                };

                xwayland = {
                  force_zero_scaling = true;
                };

              };

              exec_cmd = [
                # "pkill waybar"
                "pkill waybar; waybar"
              ];

              window_rule = [
                # "stay_focused 1,match:class zoom,match:title ^(menu window|Send chat to(\.\.\.|.*)?|Toolbar Menu)$"
                # "suppress_event maximize, match:class .*"
                # "no_focus 1,match:class ^$,match:title ^$,match:xwayland 1,match:float 1,match:fullscreen 0,match:pin 0"
                # "float 1,match:title ^Qalculate!"
                # "float 1, match:class ^.*swappy$"
                # "border_size 2, match:float 1"
                # "no_blur 1, match:class zoom"
                # "opacity 1.0 override 1.0 override, match:class ^(obs)$"
                {
                  match = {
                    title = "^(menu window|Send chat to(\.\.\.|.*)?|Toolbar Menu)$";
                    class = "zoom";
                  };
                  stay_focused = true;
                }
                # {
                #   match.class = ".*";
                #
                #   suppress_event = "maximize";
                # }

                {
                  match.class = "^$";
                  match.title = "^$";
                  match.xwayland = true;
                  match.float = true;
                  match.fullscreen = false;
                  match.pin = false;

                  no_focus = true;
                }

                {
                  match.title = "^Qalculate!";
                  float = true;
                }
                {
                  match.class = "^.*swappy$";
                  float = true;
                }
                {
                  match.float = true;
                  border_size = 2;
                }

                {
                  match.class = "^zoom$";
                  no_blur = true;
                }
                {
                  match.class = "^(obs)$";

                  opacity = "1.0 override 1.0 override";
                }
              ];
              workspace_rule = [
                {
                  workspace = "w[tv1]";
                  border_size = 0;
                }
              ];

              bind = [

                # "${modVar}, Return, exec, ${terminalVar}"
                (bind "${modVar} + Return" (dsp.exec terminalVar))
                # "${modVar}, C, killactive,"
                (bind "${modVar} + C" dsp.close)
                # "${modVar}, B, exec, ${browserVar}"
                (bind "${modVar} + B" (dsp.exec browserVar))
                # "${modVar}, V, togglefloating,"
                (bind "${modVar} + V" dsp.float)
                # "${modVar}, M, exec, wlogout"
                (bind "${modVar} + M" (dsp.exec "wlogout"))
                # "${modVar}, R, exec, ${../../../non-nix/scripts/hyprland/rofi.sh} drun"
                (bind "${modVar} + R" (dsp.exec "${../../../non-nix/scripts/hyprland/rofi.sh} drun"))
                # "${modVar}, Q, exec, ${../../../non-nix/scripts/hyprland/rofi.sh} calc"
                (bind "${modVar} + Q" (dsp.exec "${../../../non-nix/scripts/hyprland/rofi.sh} calc"))
                # "${modVar} SHIFT, R, exec, ${../../../non-nix/scripts/hyprland/rofi.sh} emoji"
                (bind "${modVar} + SHIFT + R" (dsp.exec "${../../../non-nix/scripts/hyprland/rofi.sh} emoji"))
                # "${modVar}, P, pseudo,"
                (bind "${modVar} + P" dsp.pseudo)
                # "${modVar}, S, togglesplit,"
                # "${modVar}, F, fullscreen,"
                (bind "${modVar} + F" dsp.fullscreen)
                # "${modVar} SHIFT, L, exec, hyprlock"
                (bind "${modVar} + SHIFT + L" (dsp.exec "hyprlock"))
                # "${modVar}, Print, exec, ${../../../non-nix/scripts/hyprland/screenshot.sh} m"
                (bind "${modVar} + Print" (dsp.exec "${../../../non-nix/scripts/hyprland/screenshot.sh} m"))
                # "${modVar} SHIFT, Print, exec, ${../../../non-nix/scripts/hyprland/screenshot.sh} sf"
                (bind "${modVar} + SHIFT + Print" (
                  dsp.exec "${../../../non-nix/scripts/hyprland/screenshot.sh} sf"
                ))
                # "${modVar} Ctrl, Print, exec, ${../../../non-nix/scripts/hyprland/screenshot.sh} p"
                (bind "${modVar} + CTRL + Print" (dsp.exec "${../../../non-nix/scripts/hyprland/screenshot.sh} p"))
                # "${modVar}, left, movefocus, l"
                (bind "${modVar} + left" (dsp.movefocus "l"))
                # "${modVar}, right, movefocus, r"
                (bind "${modVar} + right" (dsp.movefocus "r"))
                # "${modVar}, up, movefocus, u"
                (bind "${modVar} + up" (dsp.movefocus "u"))
                # "${modVar}, down, movefocus, d"
                (bind "${modVar} + down" (dsp.movefocus "d"))
                # "${modVar}, H, movefocus, l"
                (bind "${modVar} + H" (dsp.movefocus "l"))
                # "${modVar}, J, movefocus, d"
                (bind "${modVar} + J" (dsp.movefocus "d"))
                # "${modVar}, K, movefocus, u"
                (bind "${modVar} + K" (dsp.movefocus "u"))
                # "${modVar}, L, movefocus, r"
                (bind "${modVar} + L" (dsp.movefocus "r"))
                # "${modVar}, minus, togglespecialworkspace, magic"
                (bind "${modVar} + minus" dsp.specialworkspace)
                # "${modVar} SHIFT, minus, movetoworkspace, special:magic"
                (bind "${modVar} + SHIFT + minus" dsp.mvspecialworkspace)
                # "${modVar} SHIFT, V, exec, ${../../../non-nix/scripts/hyprland/rofi.sh} clipboard"
                (bind "${modVar} + SHIFT + V" (dsp.exec "${../../../non-nix/scripts/hyprland/rofi.sh} clipboard"))
                # "ALT, R, submap, resize"
                (bind "ALT + R" (dsp.submap "resize"))
                # "${modVar}, 1, split-workspace, 1"
                # "${modVar} SHIFT, 1, split-movetoworkspacesilent, 1"
                # "${modVar}, 2, split-workspace, 2"
                # "${modVar} SHIFT, 2, split-movetoworkspacesilent, 2"
                # "${modVar}, 3, split-workspace, 3"
                # "${modVar} SHIFT, 3, split-movetoworkspacesilent, 3"
                # "${modVar}, 4, split-workspace, 4"
                # "${modVar} SHIFT, 4, split-movetoworkspacesilent, 4"
                # "${modVar}, 5, split-workspace, 5"
                # "${modVar} SHIFT, 5, split-movetoworkspacesilent, 5"
                # "${modVar}, 6, split-workspace, 6"
                # "${modVar} SHIFT, 6, split-movetoworkspacesilent, 6"
                # "${modVar}, 7, split-workspace, 7"
                # "${modVar} SHIFT, 7, split-movetoworkspacesilent, 7"
                # "${modVar}, 8, split-workspace, 8"
                # "${modVar} SHIFT, 8, split-movetoworkspacesilent, 8"
                # "${modVar}, 9, split-workspace, 9"
                # "${modVar} SHIFT, 9, split-movetoworkspacesilent, 9"
                # "${modVar}, 0, split-workspace, 10"
                # "${modVar} SHIFT, 0, split-movetoworkspacesilent, 10"

                # "${modVar}, E, exec ${fileManagerVar}"
                (bind "${modVar} + E" (dsp.exec fileManagerVar))
              ]

              # "${modVar}, 1, split-workspace, 1"
              # "${modVar} SHIFT, 1, split-movetoworkspacesilent, 1"
              ++ builtins.concatLists (
                builtins.genList (
                  i:
                  let
                    index = lib.trivial.mod i 10;
                  in
                  [
                    (bind "${modVar} + ${toString index}" (dsp.workspace i))
                    (bind "${modVar} + SHIFT + ${toString index}" (dsp.mvworkspace i))
                  ]
                ) 10
              )
              ++
                # bindm
                [
                  #   "${modVar}, mouse:272, movewindow"
                  (bindm "${modVar} + mouse:272" dsp.drag)
                  #   "${modVar}, mouse:273, resizewindow"
                  (bindm "${modVar} + mouse:273" dsp.resize)

                ]
              ++
                # binde
                [

                  # "${modVar} SHIFT, up, exec, ${../../../non-nix/scripts/hyprland/brightness.sh} inc"
                  (binde "${modVar} + SHIFT + up" (dsp.exec "${../../../non-nix/scripts/hyprland/brightness.sh} inc"))
                  # "${modVar} SHIFT, down, exec, ${../../../non-nix/scripts/hyprland/brightness.sh} dec"
                  (binde "${modVar} + SHIFT + down" (
                    dsp.exec "${../../../non-nix/scripts/hyprland/brightness.sh} dec"
                  ))
                ]
              ++
                #bindel
                [
                  # ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
                  (bindel "XF86AudioRaiseVolume" (dsp.exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
                  # ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                  (bindel "XF86AudioLowerVolume" (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
                  # ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                  (bindel "XF86AudioMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
                  # ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                  (bindel "XF86AudioMicMute" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
                  # ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
                  (bindel "XF86MonBrightnessUp" (dsp.exec "brightnessctl s 10%+"))
                  # ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
                  (bindel "XF86MonBrightnessDown" (dsp.exec "brightnessctl s 10%-"))
                ];

              # plugin = {
              #   split-monitor-workspaces = {
              #     count = 10;
              #     keep_focused = 0;
              #     enable_notifications = 0;
              #     enable_persistent_workspaces = 1;
              #   };
              # };

            };
          extraConfig = ''
            smw.setup({
                workspace_count = 10, 
            })

          '';
          extraLuaFiles =
            let
              smwPath =
                /. + (builtins.unsafeDiscardStringContext inputs.split-monitor-workspaces.outPath) + "/lua";
              smwFiles = lib.filterAttrs (name: value: value == "regular") (builtins.readDir smwPath);
              smwAttrs = lib.mapAttrs' (
                name: value:
                lib.nameValuePair (builtins.replaceStrings [ ".lua" ] [ "" ] name) {
                  content = smwPath + "/${name}";
                  autoLoad = false;
                }
              ) smwFiles;
            in
            {
              # other extraLuaFiles
            }
            // smwAttrs;
          # submaps = {
          #   resize = {
          #     settings = {
          #       bind = [ ", escape, submap, reset" ];
          #       binde = [
          #
          #         ", right, resizeactive, 10 0"
          #         ", left, resizeactive, -10 0"
          #         ", up, resizeactive, 0 -10"
          #         ", down, resizeactive, 0 10"
          #       ];
          #     };
          #   };
          # };

        };
      };

    };
}
