return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"micangl/cmp-vimtex",
		ft = "tex",
		config = function()
			require("cmp_vimtex").setup({})
		end,
	},
	{
		"L3MON4D3/LuaSnip",

		version = "2.*",
		event = "VeryLazy",
		build = "make install_jsregexp",
		dependencies = {
			-- `friendly-snippets` contains a variety of premade snippets.
			--    See the README about individual language/framework/plugin snippets:
			--    https://github.com/rafamadriz/friendly-snippets
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			"Emtyffx/luasnip-latex-snippets.nvim",
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
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-emoji",
			{ "windwp/nvim-autopairs", opts = {} },
			{ "ray-x/lsp_signature.nvim", event = "InsertEnter", opts = {} },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

						-- For `mini.snippets` users:
						-- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
						-- insert({ body = args.body }) -- Insert at cursor
						-- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
						-- require("cmp.config").set_onetime({ sources = {} })
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<Tab>"] = cmp.mapping(function(fallback)
						-- Check if a completion menu is visible
						if cmp.visible() then
							-- If so, select the next item
							cmp.select_next_item()
						-- Otherwise, check if a snippet can be expanded or jumped into
						elseif luasnip.expand_or_jumpable() then
							-- If a snippet is active, jump to the next placeholder
							luasnip.expand_or_jump()
						else
							-- If none of the above, fall back to the default <Tab> behavior (insert a tab character)
							fallback()
						end
					end, { "i", "s" }),
					-- Map <S-Tab> (Shift + Tab) for backwards jumps
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({ { name = "lazydev" } }, {
					{ name = "nvim_lsp" },
					-- { name = 'vsnip' }, -- For vsnip users.
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "path" },
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
					{ name = "emoji" },
					{ name = "vimtex" },
				}, {
					{ name = "buffer" },
				}),
			})

			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- for name, opts in pairs(vim.lsp._enabled_configs) do
			-- 	vim.lsp.config[name].setup({
			-- 		capabilities = capabilities,
			-- 	})
			-- end

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
}
