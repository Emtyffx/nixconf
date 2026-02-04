{ inputs, config, ... }:
{
  flake.homeModules.wlogout =
    { lib, pkgs, ... }:
    {
      programs.wlogout = {
        enable = true;
      };
    };
}
