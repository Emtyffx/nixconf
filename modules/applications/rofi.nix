{ inputs, config, ... }:
{
  flake.homeModules.rofi =
    { lib, pkgs, ... }:
    {
      programs.rofi = {
        enable = true;

      };
      xdg = {
        configFile."rofi" = {
          source = ../../non-nix/rofi;
          recursive = true;
          target = "rofi";
        };
      };
    };
}
