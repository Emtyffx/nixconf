{ inputs, config, ... }:
{
  flake.homeModules.wlogout =
    { lib, pkgs, ... }:
    {
      programs.wlogout = {
        enable = true;
        layout = [
          {
            label = "shutdown";
            action = "systemctl shutdown";
            text = "Shutdown";
            keybind = "s";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";

          }
          {
            label = "hibernate";
            action = "systemctl hibernate";
            text = "Hibernate";
            keybind = "h";
          }
          {
            label = "suspend";
            action = "systemctl suspend";
            text = "Suspend";
            keybind = "u";
          }
          {
            label = "lock";
            action = "hyprlock";
            text = "Lock";
            keybind = "l";
          }
          {
            label = "logout";
            action = "hyprctl dispatch exit";
            text = "Logout";
            keybind = "g";
          }
        ];
      };
    };
}
