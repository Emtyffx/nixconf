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
				typescriptreact = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				sql = { "pg_format" },
				postgresql = { "pg_format" }
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
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Open harpoon files" })
			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end)
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
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash treesitter",
			},
		},
	},
	{
		"anurag3301/nvim-platformio.lua",
		cmd = { "Pioinit", "Piorun", "Piocmdh", "Piocmdf", "Piolib", "Piomon", "Piodebug", "Piodb" },

		-- optional: cond used to enable/disable platformio
		-- based on existance of platformio.ini file and .pio folder in cwd.
		-- You can enable platformio plugin, using :Pioinit command
		cond = function()
			-- local platformioRootDir = vim.fs.root(vim.fn.getcwd(), { 'platformio.ini' }) -- cwd and parents
			local platformioRootDir = (vim.fn.filereadable("platformio.ini") == 1) and vim.fn.getcwd() or nil
			if platformioRootDir then
				-- if platformio.ini file exist in cwd, enable plugin to install plugin (if not istalled) and load it.
				vim.g.platformioRootDir = platformioRootDir
			elseif (vim.uv or vim.loop).fs_stat(vim.fn.stdpath("data") .. "/lazy/nvim-platformio.lua") == nil then
				-- if nvim-platformio not installed, enable plugin to install it first time
				vim.g.platformioRootDir = vim.fn.getcwd()
			else -- if nvim-platformio.lua installed but disabled, create Pioinit command
				vim.api.nvim_create_user_command(
					"Pioinit",
					function() --available only if no platformio.ini and .pio in cwd
						vim.api.nvim_create_autocmd("User", {
							pattern = { "LazyRestore", "LazyLoad" },
							once = true,
							callback = function(args)
								if args.match == "LazyRestore" then
									require("lazy").load({ plugins = { "nvim-platformio.lua" } })
								elseif args.match == "LazyLoad" then
									vim.notify("PlatformIO loaded", vim.log.levels.INFO, { title = "PlatformIO" })
									vim.cmd("Pioinit")
								end
							end,
						})
						vim.g.platformioRootDir = vim.fn.getcwd()
						require("lazy").restore({ plguins = { "nvim-platformio.lua" }, show = false })
					end,
					{}
				)
			end
			return vim.g.platformioRootDir ~= nil
		end,

		config = function()
			local pok, platformio = pcall(require, "platformio")
			if pok then
				platformio.setup({
					lsp = "clangd",
				})
			end
		end,

		-- Dependencies are lazy-loaded by default unless specified otherwise.
		dependencies = {
			{ "akinsho/toggleterm.nvim" },
			{ "nvim-telescope/telescope.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-lua/plenary.nvim" },
			{ "folke/which-key.nvim" },
		},
	},
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle, desc = "UndoTree" },
		}
	},

	{
		"mistweaverco/kulala.nvim",
		keys = {
			{
				"<leader>Rs",
				function()
					require('kulala').run()
				end,
				desc = "Send request"
			},
			{
				"<leader>Ra",
				function()
					require('kulala').run_all()
				end,
				desc = "Send all requests"
			},
			{
				"<leader>Rb",
				function()
					require('kulala').scratchpad()
				end,
				desc = "Open scratchpad"
			},
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = false,
			global_keymaps_prefix = "<leader>R",
			kulala_keymaps_prefix = "",
		},
	},
}
