{ inputs, config, ... }:
{
  flake.modules.nixos.hyprland =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;

      };
      environment.variables = lib.mkIf (config.hardware.nvidia.modesetting.enable or false) {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
        # ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
          pkgs.xdg-desktop-portal-gtk
        ];
        # config.common.default = "*";
        # config.common."org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };

      environment.systemPackages = with pkgs; [
        wl-clipboard
        cliphist
        grimblast
        hyprpicker
        hypridle
        hyprlock
        swww
        # swappy
        gradia
        gsettings-desktop-schemas
        glib
        adwaita-icon-theme
      ];
      environment.sessionVariables = {
        XDG_DATA_DIRS = [
          "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
        ];
        ADW_DISABLE_PORTAL = "1";

      };
    };
}
