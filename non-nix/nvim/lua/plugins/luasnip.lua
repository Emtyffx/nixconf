return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.5.0",
		build = "make install_jsregexp",
		dependencies = {

			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		config = function()
			local ls = require("luasnip")
			ls.config.set_config({
				update_events = { "TextChanged", "TextChangedI" },
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
			})
			require("luasnip.loaders.from_lua").lazy_load({
				paths = { vim.fn.stdpath("config") .. "/lua/luasnip/" },
			})
			vim.keymap.set({ "i" }, "<C-k>", function()
				ls.expand()
			end, { silent = true, desc = "expand autocomplete" })
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.jump(1)
			end, { silent = true, desc = "next autocomplete" })
			vim.keymap.set({ "i", "s" }, "<C-L>", function()
				ls.jump(-1)
			end, { silent = true, desc = "previous autocomplete" })
			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true, desc = "select autocomplete" })
		end,
	},
}
