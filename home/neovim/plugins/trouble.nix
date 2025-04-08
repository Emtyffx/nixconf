{ config, pkgs, ... }:
{
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
    };
  };
}
