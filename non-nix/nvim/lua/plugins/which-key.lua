return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			local wk = require("which-key")
			wk.add({
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>lg", desc = "[L]azy[G]it" },
			})
		end,
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Show keybinds (which-key)",
			},
		},
	},
}
