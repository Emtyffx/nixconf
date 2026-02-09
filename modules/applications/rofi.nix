{ inputs, config, ... }:
{
  flake.homeModules.rofi =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        cliphist
      ];
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
