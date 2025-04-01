{ config, pkgs, ... }:
{
  programs.nixvim = {
    plugins.harpoon = {
      enable = true;
      keymaps = {
        addFile = "<leader>hf";
        toggleQuickMenu = "<leader>hm";
        gotoTerminal = {
          "1" = "<C-j>";
          "2" = "<C-k>";
          "3" = "<C-l>";
          "4" = "<C-m>";
        };
      };
    };
  };
}
