{
  config,
  inputs,
  ...
}:
let
  meta = config.flake.meta;
  tmuxSessionizerScript = "${../../non-nix/scripts/tmux-sessionizer.sh}";
in
{
  flake.homeModules.kitty =

    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.theming = {
        kittyThemePath = lib.mkOption {
          type = lib.types.path;
          default = "${../../non-nix/kitty-themes/gruvbox-dark.conf}";

          description = "Path to the kitty theme";
        };
      };

      config = {
        programs.kitty = {
          enable = meta.defaults.terminal == "kitty";
          settings = {
            include = "${config.theming.kittyThemePath}";

            background_opacity = 0.85;
            confirm_os_window_close = 0;

            window_padding_width = 6;

          };

          font.name = "Fira Code";
          font.size = 12;

          keybindings = {
            "ctrl+f" = "launch --type=overlay ${tmuxSessionizerScript}";
          };

          shellIntegration = {
            enableBashIntegration = true;
            enableZshIntegration = true;
          };

        };
      };
    };
}
