return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		dependencies = {
			{
				"windwp/nvim-ts-autotag",
				opts = {
					opts = {
						enable_close = true,
						enable_rename = true,
						enable_close_on_slash = false,
					},
				},
			},
		},

		config = function()
			require("nvim-treesitter").setup({
				highlight = {
					enable = true,
				},
			})
			require("nvim-treesitter").install({
				"c",
				"nix",
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
				"scss",
				"rust",
			})
		end,
	},
}
