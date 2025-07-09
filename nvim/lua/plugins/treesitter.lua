return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
		build = ":TSUpdate",
		lazy = vim.fn.argc(1) == 0,
		init = function()
			require("nvim-treesitter.query_predicates")
		end,
		cmd = { "TSUpdate", "TSUpdateSync", "TSInstall" },
		-- @type TSConfig
		opts = {

			ensure_installed = {
				"c",
				"cpp",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"javascript",
				"typescript",
				"vue",
				"svelte",
				"nix",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-i>",
					node_incremental = "<C-i>",
					scope_incremental = "<C-S-i>",
					node_decremental = "<BS>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter").setup()
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
