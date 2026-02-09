{ inputs, config, ... }:
{
  flake.homeModules.texlive =
    { lib, pkgs, ... }:
    {
      programs.texlive = {
        enable = true;
        extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
      };
    };
}
