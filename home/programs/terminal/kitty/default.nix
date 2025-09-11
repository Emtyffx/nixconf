{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.myKittyTheme = {
    enable = lib.mkEnableOption "Enable custom kitty theme";
    themePath = lib.mkOption {
      type = lib.types.path;
      description = "Path to the theme.conf for the current kitty theme";
    };
  };
  config = {

    programs.kitty = {
      enable = true;
      settings =
        # (lib.mkIf config.myKittyTheme.enable {
        #   include = "${config.myKittyTheme.themePath}";
        # })
        (if config.myKittyTheme.enable then { include = "${config.myKittyTheme.themePath}"; } else { }) // {
          background_opacity = 0.85;
          # background_blur = 1;
          confirm_os_window_close = 0;
          font_size = 12;
        };
      shellIntegration.enableBashIntegration = true;
      shellIntegration.enableZshIntegration = true;
    };
  };
}
