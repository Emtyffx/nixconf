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
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      };

      environment.systemPackages = with pkgs; [
        wl-clipboard
        cliphist
        grimblast
        hyprpicker
        hypridle
        hyprlock
        swww
      ];
    };
}
