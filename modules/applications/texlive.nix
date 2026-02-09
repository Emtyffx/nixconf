{ inputs, config, ... }:
{
  flake.homeModules =
    { lib, pkgs, ... }:
    {
      programs.texlive = {
        enable = true;
        packageSet = pkgs.texliveFull;
      };
    };
}
