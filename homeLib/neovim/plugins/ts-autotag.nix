{ config, pkgs, ... }:
{
  programs.nixvim = {
    plugins.ts-autotag = {
      enable = true;
    };
  };
}
