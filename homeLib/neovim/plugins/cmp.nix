{ config, pkgs, ... }:
{
  programs.nixvim = {
    plugins.luasnip.enable = true;
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "luasnip"; }
      ];
      settings.mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true; })";
        "<Tab>" = ''
          				    cmp.mapping(function(fallback)
                                                local luasnip = require('luasnip')
          				      local check_backspace = function()
          					local col = vim.fn.col "." - 1
          					return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
          				      end

          				      if cmp.visible() then
          					cmp.select_next_item()
          				      elseif luasnip.expandable() then
          					luasnip.expand()
          				      elseif luasnip.expand_or_jumpable() then
          				      	luasnip.expand_or_jump()
          				      elseif check_backspace() then
          				      	fallback()
          				      else
          					fallback()
          				      end
          				    end, { "i", "s" })	
          				'';
      };
      luaConfig.post = ''
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      '';
    };
    plugins.cmp-emoji.enable = true;
  };
}
