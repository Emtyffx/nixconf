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
        plugins = with pkgs; [
          rofi-calc
        ];

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
