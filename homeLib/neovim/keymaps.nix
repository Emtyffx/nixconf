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
      # Neotree removed
      # {
      #   action = "<cmd>Neotree toggle<CR>";
      #   key = "<leader>e";
      #   options = {
      #     desc = "Toggle Neotree view";
      #   };
      # }
      {
        action = "<cmd>wincmd k<CR>";
        key = "<C-k>";
        options = {
          desc = "Move up window";
        };
      }
      {
        action = "<cmd>wincmd h<cr>";
        key = "<c-h>";
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
      {
        action = "<cmd>qa!<CR>";
        key = "<leader>qq";
        options = {
          desc = "Quit all";
        };
      }
      {
        action = "<cmd>Trouble diagnostics toggle<CR>";
        key = "<leader>xx";
        options = {
          desc = "Diagnostics (Trouble)";
        };
      }
      {
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
        key = "<leader>xX";
        options = {
          desc = "Buffer Diagnostics (Trouble)";
        };
      }
      {
        action = "<cmd>Trouble symbols toggle focus=false<CR>";
        key = "<leader>cs";
        options = {
          desc = "Symbols (Trouble)";
        };
      }
      {
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<CR>";
        key = "<leader>cl";
        options = {
          desc = "LSP Definitions / references / ... (Trouble)";
        };
      }
      {
        action = "<cmd>Trouble loclist toggle<CR>";
        key = "<leader>xL";
        options = {
          desc = "Location List (Trouble)";
        };
      }
      {
        action = "<cmd>Trouble qflist toggle<CR>";
        key = "<leader>xQ";
        options = {
          desc = "Quickfix List (Trouble)";
        };
      }
      {
        action = "<cmd>Ex<CR>";
        key = "<leader>au";
        options = {
          desc = "Open file browser";
        };

      }
      {
        action = "<cmd>Oil<CR>";
        key = "-";
        options = {
          desc = "Open OIL";
        };
      }
    ];
  };
}
