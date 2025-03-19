{ config, pkgs, ... }:
{
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>bp<CR>";
        key = "[b";
        options = {
          desc = "Previous buffer";
        };
      }
      {
        action = "<cmd>bn<CR>";
        key = "]b";
        options = {
          desc = "Next buffer";
        };
      }
      {
        action = "<cmd>bd<CR>";
        key = "bd";
        options = {
          desc = "Close current buffer";
        };
      }
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<leader>e";
        options = {
          desc = "Toggle Neotree view";
        };
      }
      {
        action = "<cmd>wincmd k<CR>";
        key = "<C-k>";
        options = {
          desc = "Move up window";
        };
      }
      {
        action = "<cmd>wincmd h<CR>";
        key = "<C-h>";
        options = {
          desc = "Move left window";
        };
      }
      {
        action = "<cmd>wincmd j<CR>";
        key = "<C-j>";
        options = {
          desc = "Move window down";
        };
      }
      {
        action = "<cmd>wincmd l<CR>";
        key = "<C-l>";
        options = {
          desc = "Move window right";
        };
      }

      {
        action = "<cmd>vsplit<CR>";
        key = "<leader>wv";
        options = {
          desc = "Split vertically";
        };

      }
      {
        action = "<cmd>split<CR>";
        key = "<leader>ws";
        options = {
          desc = "Horizontal split";
        };
      }
      # configuration of the clipboard
      {
        action = "\"+y";
        key = "<leader>y";
        mode = [
          "n"
          "x"
        ];
        options = {
          desc = "Copy from system clipboard";
        };
      }
      {
        action = "\"+yg_";
        key = "<leader>Y";
        mode = [
          "n"
          "x"
        ];
        options = {
          desc = "Copy from system clipboard";
        };
      }
      {
        action = "\"+p";
        key = "<leader>p";
        mode = [
          "n"
          "x"
        ];
        options = {
          desc = "Paste from system clipboard";
        };
      }
      {
        action = "\"+P";
        key = "<leader>P";
        mode = [
          "n"
          "x"
        ];
        options = {
          desc = "Paste from system clipboard";
        };
      }

    ];
  };
}
