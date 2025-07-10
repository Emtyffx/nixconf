return {
	"tpope/vim-sleuth",
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				nix = { "nixfmt" },
				css = { "prettier" },
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"theprimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({})

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Add to harpoon" })

			vim.keymap.set("n", "<leader>sh", function()
				require("utils").toggle_telescope_for_harpoon(harpoon:list())
			end, { desc = "Open harpoon files" })
		end,
	},
	{
		"echasnovski/mini.surround",
		version = false,
		opts = {},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		keys = {
			{
				"zk",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"zl",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash treesitter",
			},
		},
	},
}
