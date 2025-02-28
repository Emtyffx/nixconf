{ config, lib, pkgs, ...}:
{
	home.packages = lib.mkAfter (with pkgs; [
		grimblast
		wofi
	]);
	wayland.windowManager.hyprland = {
		enable = true; package = pkgs.hyprland; xwayland.enable = true;

		systemd.enable = true;
		settings = {
			"$mod" = "SUPER";	
		monitor = ",preferred,auto,auto";
		"$terminal" = "kitty";
		"$menu" = "wofi --show drun";
		input = {
			kb_layout = "us, ru, ua";
			kb_options = "grp:win_space_toggle";
		};
		animations = {
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
    bind =
      [
        "$mod, F, exec, firefox"
        ", Print, exec, grimblast copy area"
	"$mod, Q, exec, $terminal"
	"$mod, C, killactive,"
	"$mod, M, exit, "
	"$mod, P, pseudo,"
	"$mod, R, exec, $menu"
	"$mod, J, togglesplit,"
	"$mod, mouse_down, workspace, e+1"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );	
      bindm = [
      	"$mod, mouse:272, movewindow"	
	"$mod, mouse:273, resizewindow"
      ];
		};

	};
}
