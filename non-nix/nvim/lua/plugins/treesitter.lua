return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		version = false,
		dependencies = {
			{
				"windwp/nvim-ts-autotag",
				opts = {
					opts = {
						enable_close = true,
						enable_rename = true,
						enable_close_on_slash = true,
					},
				},
			},
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
		cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
		opts_extend = { "ensure_installed" },
		build = ":TSUpdate",
		lazy = false,
		-- init = function()
		-- 	require("nvim-treesitter.query_predicates")
		-- end,
		-- @type TSConfig
		opts = {

			ensure_installed = {
				"c",
				"nixd",
				"cpp",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"latex",
				"bibtex",
				"markdown_inline",
				"javascript",
				"typescript",
				"tsx",
				"jsx",
				"html",
				"vue",
				"svelte",
				"nix",
			},
			-- auto_install = true,
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
			require("nvim-treesitter").install(opts.ensure_installed)
			require("nvim-treesitter.config").setup(opts)
		end,
	},
}
