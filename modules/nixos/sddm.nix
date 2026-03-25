{ inputs, config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.sddm =
    { pkgs, ... }:
    let
      colors = meta.defaults.theme.colors;
      wallpaper = meta.defaults.theme.wallpaper;
      themeConfig = {
        ScreenWidth = "1920";
        ScreenHeight = "1080";
        ScreenPadding = "";

        Font = "Fira Code";
        FontSize = "13";

        KeyboardSize = "0.4";
        RoundCorners = "20";

        Locale = "";
        HourFormat = "HH:mm";
        DateFormat = "dddd d MMMM";

        HeaderText = "";

        BackgroundPlaceholder = "";
        Background = wallpaper;

        BackgroundSpeed = "";

        PauseBackground = "";
        DimBackground = "0.0";
        CropBackground = "true";
        BackgroundHorizontalAlignment = "center";
        BackgroundVerticalAlignment = "center";

        HeaderTextColor = colors.fg;
        DateTextColor = colors.fg;
        TimeTextColor = colors.fg;

        FormBackgroundColor = colors.bg;
        BackgroundColor = colors.bg;
        DimBackgroundColor = colors.bg0-h;

        LoginFieldBackgroundColor = colors.bg1;
        PasswordFieldBackgroundColor = colors.bg1;

        LoginFieldTextColor = colors.fg;
        PasswordFieldTextColor = colors.fg;
        UserIconColor = colors.fg;
        PasswordIconColor = colors.fg;

        PlaceholderTextColor = colors.fg2;
        WarningColor = colors.yellow;

        LoginButtonTextColor = colors.fg;
        LoginButtonBackgroundColor = colors.bg1;

        SystemButtonsIconsColor = colors.fg;
        SessionButtonTextColor = colors.fg;
        VirtualKeyboardButtonTextColor = colors.fg;

        DropdownTextColor = colors.fg;
        DropdownSelectedBackgroundColor = colors.bg1;
        DropdownBackgroundColor = colors.bg;

        HighlightTextColor = colors.fg0;
        HighlightBackgroundColor = colors.bg1;
        HighlightBorderColor = colors.fg;

        HoverUserIconColor = colors.fg2;
        HoverPasswordIconColor = colors.fg2;
        HoverSystemButtonsIconsColor = colors.fg2;
        HoverSessionButtonTextColor = colors.fg2;
        HoverVirtualKeyboardButtonTextColor = colors.fg2;
        PartialBlur = "false";
        FullBlur = "";
        BlurMax = "";
        Blur = "";

        HaveFormBackground = "false";
        FormPosition = "left";
        VirtualKeyboardPosition = "center";

        HideVirtualKeyboard = "false";
        HideSystemButtons = "false";
        HideLoginButton = "false";

        ForceLastUser = "true";
        PasswordFocus = "true";
        HideCompletePassword = "true";
        AllowEmptyPassword = "false";
        AllowUppercaseLettersInUsernames = "true";
        BypassSystemButtonsChecks = "false";
        RightToLeftLayout = "false";

        TranslatePlaceholderUsername = "";
        TranslatePlaceholderPassword = "";
        TranslateLogin = "";
        TranslateLoginFailedWarning = "";
        TranslateCapslockWarning = "";
        TranslateSuspend = "";
        TranslateHibernate = "";
        TranslateReboot = "";
        TranslateShutdown = "";
        TranslateSessionSelection = "";
        TranslateVirtualKeyboardButtonOn = "";
        TranslateVirtualKeyboardButtonOff = "";

      };
      sddm-astronaut-theme = pkgs.sddm-astronaut.override {
        inherit themeConfig;
      };
    in
    {

      services.displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
          theme = "${sddm-astronaut-theme}/share/sddm/themes/sddm-astronaut-theme";
          extraPackages = with pkgs; [
            sddm-astronaut-theme
          ];
        };
      };
      services.xserver.enable = true;

      # services.displayManager.gdm.enable = true;
      # services.displayManager.sddm = {
      #   enable = true;
      #   wayland.enable = true;
      # };

      environment.systemPackages = with pkgs; [
        sddm-astronaut-theme
        nerd-fonts.jetbrains-mono
        kdePackages.qtbase
        kdePackages.qtdeclarative
        kdePackages.qtmultimedia
        kdePackages.qtsvg
        kdePackages.qtwayland # Essential if you use Wayland
        kdePackages.qt5compat # Often needed for older themes ported to Qt6

      ];

    };
}
