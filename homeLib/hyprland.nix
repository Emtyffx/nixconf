{ config, lib, pkgs, ...}:
{
	home.packages = lib.mkAfter (with pkgs; [
		grimblast
		wofi
	]);
	wayland.windowManager.hyprland = {
		enable = true;
		package = pkgs.hyprland;
		xwayland.enable = true;

		systemd.enable = true;
		settings = {
			"$mod" = "SUPER";	
		monitor = ",preferred,auto,auto";
		"$terminal" = "kitty";
		"$menu" = "wofi -show drun";
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
