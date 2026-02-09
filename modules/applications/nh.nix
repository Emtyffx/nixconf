{ inputs, config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.homeModules.nh =
    { lib, pkgs, ... }:
    {
      programs.nh = {
        enable = true;
        flake = "/home/${meta.owner.username}/nixconf";
        clean = {
          enable = true;
          dates = "weekly";
        };
      };
    };
}
