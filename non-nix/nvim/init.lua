-- setup options and keybinds
require("options")
require("keymaps")
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Setup lazy.nvim
require("lazy").setup({

	spec = {

		"nvim-lua/plenary.nvim",
		-- {
		-- 	"williamboman/mason-lspconfig.nvim",
		-- 	dependencies = { { "williamboman/mason.nvim", opts = {} } },
		-- 	-- Ensure this runs before nvim-lspconfig to set up the configuration
		-- 	config = function()
		-- 		require("mason-lspconfig").setup({
		-- 			-- A list of servers to install automatically (optional)
		-- 			ensure_installed = {
		-- 				"lua_ls",
		-- 				"gopls",
		-- 				"vtsls",
		-- 				"cssls",
		-- 				"nil_ls",
		-- 				"html",
		-- 				"pyright",
		-- 				"emmet_ls",
		-- 				"tailwindcss",
		-- 				"clangd",
		-- 				"bashls",
		-- 				"sqlls",
		-- 				"rust_analyzer",
		-- 				-- The servers you listed above
		-- 			},
		-- 		})
		-- 	end,
		-- },
		{ import = "plugins" },
		-- add your plugins here
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
