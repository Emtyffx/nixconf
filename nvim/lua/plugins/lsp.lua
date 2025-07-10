return {
	{
		"neovim/nvim-lspconfig",
		--		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local servers = {}
			servers.lua_ls = {}
			servers.nixd = {}
			servers.gopls = {}
			servers.vtsls = {}
			servers.clangd = {}
			servers.pyright = {}
			servers.cssls = {}
			servers.html = {}
			servers.vue_ls = {}
			servers.svelte = {}
			-- the rust-analyzer is enabled via the rustaceanvim plugin
			for name, opts in pairs(servers) do
				vim.lsp.enable(name)
				vim.lsp.config(name, opts)
			end
			vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })

			-- Execute a code action, usually your cursor needs to be on top of an error
			-- or a suggestion from your LSP for this to activate.
			vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, { desc = "[G]oto Code [A]ction" })

			-- Find references for the word under your cursor.
			vim.keymap.set("n", "grr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })

			-- Jump to the implementation of the word under your cursor.
			--  Useful when your language has ways of declaring types without an actual implementation.
			vim.keymap.set(
				"n",
				"gri",
				require("telescope.builtin").lsp_implementations,
				{ desc = "[G]oto [I]mplementation" }
			)

			-- Jump to the definition of the word under your cursor.
			--  This is where a variable was first declared, or where a function is defined, etc.
			--  To jump back, press <C-t>.
			vim.keymap.set("n", "grd", require("telescope.builtin").lsp_definitions, { desc = "[G]oto [D]efinition" })

			-- WARN: This is not Goto Definition, this is Goto Declaration.
			--  For example, in C this would take you to the header.
			vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })

			-- Fuzzy find all the symbols in your current document.
			--  Symbols are things like variables, functions, types, etc.
			vim.keymap.set(
				"n",
				"gO",
				require("telescope.builtin").lsp_document_symbols,
				{ desc = "Open Document Symbols" }
			)

			-- Fuzzy find all the symbols in your current workspace.
			--  Similar to document symbols, except searches over your entire project.
			vim.keymap.set(
				"n",
				"gW",
				require("telescope.builtin").lsp_dynamic_workspace_symbols,
				{ desc = "Open Workspace Symbols" }
			)

			-- Jump to the type of the word under your cursor.
			--  Useful when you're not sure what type a variable is and you want to see
			--  the definition of its *type*, not where it was *defined*.
			vim.keymap.set(
				"n",
				"grt",
				require("telescope.builtin").lsp_type_definitions,
				{ desc = "[G]oto [T]ype Definition" }
			)

			-- configure virtual text diagnostics
			vim.diagnostic.config({
				virtual_text = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
					linehl = {
						[vim.diagnostic.severity.ERROR] = "ErrorMsg",
						[vim.diagnostic.severity.WARN] = "WarningMsg",
						[vim.diagnostic.severity.HINT] = "HintMsg",
						[vim.diagnostic.severity.INFO] = "InfoMsg",
					},
				},
			})
			-- vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
			-- vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
			-- vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
			-- vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
		config = function()
			vim.g.rustaceanvim = {
				server = {
					default_settings = {
						["rust-analyzer"] = {
							checkOnSave = false,
							diagnostics = {
								enable = true,
								experimental = {
									enable = true,
								},
							},
						},
					},
				},
			}
		end,
	},
}
