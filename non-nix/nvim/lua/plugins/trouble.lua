return {
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
		keys = {
			{
				"<leader>tt",
				"<cmd>Trouble diagnostics toggle<CR>zzzv",
				desc = "Open trouble",
			},
			{
				"<leader>tq",
				"<cmd>Trouble qflist toggle<CR>zzzv",
				desc = "Open trouble [qflist]",
			},
			{
				"[t",
				function()
					require("trouble").prev({ skip_groups = true, jump = true })
				end,
				desc = "Trouble prev",
			},
			{
				"]t",
				function()
					require("trouble").next({ skip_groups = true, jump = true })
				end,
				desc = "Trouble next",
			},
		},
	},
}
