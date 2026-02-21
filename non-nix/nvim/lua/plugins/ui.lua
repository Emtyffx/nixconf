return {

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			presets = {
				command_palette = true,
			},
			routes = {
				{
					view = "notify",
					filter = {
						event = "msg_show",
						kind = {
							"shell_out",
							"shell_err",
						},
					},
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = { background_colour = "#000000" },
				config = function(_, opts)
					require("notify").setup(opts)
				end,
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
		keys = {
			{
				"<leader>sf",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Telescope find files",
			},
			{
				"<leader>sg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Telescope live grep",
			},
			{
				"<leader>sb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Telescope buffers",
			},
		},
	},
	-- {
	-- 	"nvim-neo-tree/neo-tree.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-tree/nvim-web-devicons",
	-- 		"MunifTanjim/nui.nvim",
	-- 	},
	--
	-- 	lazy = false,
	-- 	-- @module "neo-tree"
	-- 	-- @type neotree.Config?
	-- 	opts = {},
	-- 	config = function(_, opts)
	-- 		require("neo-tree").setup(opts)
	-- 		vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle neotree" })
	-- 	end,
	-- },

	{
		'stevearc/oil.nvim',
		lazy = false,
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
		keys = {
			{
				'-',
				'<CMD>Oil --float<CR>',
				desc = "Toggle oil",

				mode = { "n" }
			}
		},
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},

		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Toggle LazyGit" },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			opts = {
				options = {
					icons_enabled = true,
					component_separators = "|",
					section_separators = "",
				},
				sections = {
					lualine_x = {
						{
							require("noice").api.status.mode.get,
							cond = require("noice").api.status.mode.has,
						},
						{
							require("noice").api.status.command.get,
							cond = require("noice").api.status.command.has,
						},
					},
					lualine_a = {
						{
							"buffers",
						},
					},
				},
			}
			require("lualine").setup(opts)
		end,
	},
	-- replaced with buffers in lualine
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	version = "*",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	opts = {
	-- 		options = {
	-- 			offsets = {
	-- 				{
	-- 					filetype = "neo-tree",
	-- 					text = "Neotree",
	-- 					separator = true,
	-- 					text_align = "left",
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
	{
		"folke/which-key.nvim",
		opts = {},
		event = "VeryLazy",
	},
	{
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	},
	-- {
	-- 	"tris203/precognition.nvim",
	-- 	opts = {},
	-- },
	{
		"IogaMaster/neocord",
		event = "VeryLazy",
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			{ "kevinhwang91/promise-async" },
		},
		config = function()
			require("ufo").setup({})
			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zK", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek fold" })
		end,
		-- keys = {
		-- 	{
		-- 		"zR",
		-- 		require("ufo").openAllFolds,
		-- 		desc = "Open all folds",
		-- 	},
		-- 	{
		-- 		"zM",
		-- 		require("ufo").closeAllFolds,
		-- 		desc = "Close all folds",
		-- 	},
		-- 	{
		-- 		"zK",
		-- 		function()
		-- 			local winid = require("ufo").peekFoldedLinesUnderCursor()
		-- 			if not winid then
		-- 				vim.lsp.buf.hover()
		-- 			end
		-- 		end,
		-- 	},
		-- },
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			vim.keymap.set(
				"n",
				"<leader>gh",
				":Gitsigns preview_hunk<CR>",
				{ noremap = true, desc = "Gitsigns: preview_hunk" }
			)
			vim.keymap.set(
				"n",
				"<leader>gi",
				":Gitsigns preview_hunk_inline<CR>",
				{ noremap = true, desc = "Gitsigns: preview_hunk_inline" }
			)
		end,
	},
}
