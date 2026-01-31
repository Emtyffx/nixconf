{ inputs, config, ... }:
{
  flake.homeModules.hypridle = {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          lock_cmd = "hyprlock";
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";

          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
