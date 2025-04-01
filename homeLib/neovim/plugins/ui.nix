{ config, pkgs, ... }:
{
  programs.nixvim = {
    plugins.which-key.enable = true;
    plugins.which-key.autoLoad = true;
    plugins.nvim-ufo.enable = true;
  };
}
