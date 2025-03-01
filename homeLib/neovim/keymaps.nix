{ config, pkgs, ... }:
{
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>bp<CR>";
        key = "[b";
      }
      {
        action = "<cmd>bn<CR>";
        key = "]b";
      }
      {
        action = "<cmd>bd<CR>";
        key = "bd";
      }
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<leader>e";
      }

    ];
  };
}
