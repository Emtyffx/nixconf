{ config, pkgs, ... }:
{
  programs.nixvim = {
    plugins.lz-n.enable = true;
  };
}
