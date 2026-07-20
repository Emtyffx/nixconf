return {
	{
		"stevearc/oil.nvim",
		opts = {
			view_options = { show_hidden = true },
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		lazy = true,
		keys = {
			{
				"-",
				"<cmd>Oil --float<CR>",
				mode = { "n" },
			},
		},
	},
}
