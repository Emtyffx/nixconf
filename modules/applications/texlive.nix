{ inputs, config, ... }:
{
  flake.homeModules.texlive =
    { lib, pkgs, ... }:
    {
      programs.texlive = {
        enable = true;
        packageSet = pkgs.texliveFull;
      };
    };
}
