{ config, pkgs, ... }:
{
  programs.nixvim = {
    plugins.treesitter.enable = true;
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
        };
        format_on_save = # Lua
          ''
                    function(bufnr)
                      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                      end

                      local function on_format(err)
            	  	return
            	  end

                      return { timeout_ms = 200, lsp_fallback = true }, on_format
                     end
          '';
      };
    };
  };
}
