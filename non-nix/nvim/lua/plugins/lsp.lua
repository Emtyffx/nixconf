return {
	{
		"neovim/nvim-lspconfig",
		--		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local servers = {}
			servers.lua_ls = {}
			servers.gopls = {}
			servers.vtsls = {}
			servers.cssls = {}
			servers.html = {}
			servers.vuels = {}
			servers.svelte = {}
			servers.neocmake = {}
			servers.pyright = {}
			servers.emmet_ls = {}
			servers.tailwindcss = {}
			servers.nixd = {}
			-- servers.ccls = {}
			servers.clangd = {

				mason = false,
				cmd = {
					"clangd",
					"--background-index",
				},
			}
			servers.sqls = {}
			servers.arduino_language_server = {}
			-- the rust-analyzer is enabled via the rustaceanvim plugin
			for name, opts in pairs(servers) do
				vim.lsp.enable(name)
				vim.lsp.config(name, opts)
			end
			vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })

			-- Execute a code action, usually your cursor needs to be on top of an error
			-- or a suggestion from your LSP for this to activate.
			vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, { desc = "[G]oto Code [A]ction" })

			-- another keymap for code action(faster)
			vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })

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
	{
		"Civitasv/cmake-tools.nvim",
		ft = { "c", "cpp", "objc", "objcpp", "cmake" },
		config = function()
			require("cmake-tools").setup({
				cmake_command = "cmake",                              -- this is used to specify cmake command path
				ctest_command = "ctest",                              -- this is used to specify ctest command path
				cmake_regenerate_on_save = true,                      -- auto generate when save CMakeLists.txt
				cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
				cmake_build_options = {},                             -- this will be passed when invoke `CMakeBuild`
				-- support macro expansion:
				--       ${kit}
				--       ${kitGenerator}
				--       ${variant:xx}
				cmake_build_directory = "out/${variant:buildType}", -- this is used to specify generate directory for cmake, allows macro expansion, relative to vim.loop.cwd()
				cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
				cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
				cmake_kits_path = nil,                  -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
				cmake_variants_message = {
					short = { show = true },            -- whether to show short message
					long = { show = true, max_length = 40 }, -- whether to show long message
				},
				cmake_dap_configuration = {             -- debug settings for cmake
					name = "cpp",
					type = "codelldb",
					request = "launch",
					stopOnEntry = false,
					runInTerminal = true,
					console = "integratedTerminal",
				},
				cmake_executor = {     -- executor to use
					name = "quickfix", -- name of the executor
					opts = {},         -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
					default_opts = {   -- a list of default and possible values for executors
						quickfix = {
							show = "always", -- "always", "only_on_error"
							position = "belowright", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
							size = 10,
							encoding = "utf-8", -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
							auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
						},
						toggleterm = {
							direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
							close_on_exit = false, -- whether close the terminal when exit
							auto_scroll = true, -- whether auto scroll to the bottom
						},
						overseer = {
							new_task_opts = {
								strategy = {
									"toggleterm",
									direction = "horizontal",
									autos_croll = true,
									quit_on_exit = "success",
								},
							}, -- options to pass into the `overseer.new_task` command
							on_new_task = function(task)
								require("overseer").open({ enter = false, direction = "right" })
							end, -- a function that gets overseer.Task when it is created, before calling `task:start`
						},
						terminal = {
							name = "Main Terminal",
							prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
							split_direction = "horizontal", -- "horizontal", "vertical"
							split_size = 11,

							-- Window handling
							single_terminal_per_instance = true, -- Single viewport, multiple windows
							single_terminal_per_tab = true, -- Single viewport per tab
							keep_terminal_static_location = true, -- Static location of the viewport if avialable

							-- Running Tasks
							start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
							focus = false, -- Focus on terminal when cmake task is launched.
							do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
						},         -- terminal executor uses the values in cmake_terminal
					},
				},
				cmake_runner = { -- runner to use
					name = "terminal", -- name of the runner
					opts = {},  -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
					default_opts = { -- a list of default and possible values for runners
						quickfix = {
							show = "always", -- "always", "only_on_error"
							position = "belowright", -- "bottom", "top"
							size = 10,
							encoding = "utf-8",
							auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
						},
						toggleterm = {
							direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
							close_on_exit = false, -- whether close the terminal when exit
							auto_scroll = true, -- whether auto scroll to the bottom
						},
						overseer = {
							new_task_opts = {
								strategy = {
									"toggleterm",
									direction = "horizontal",
									autos_croll = true,
									quit_on_exit = "success",
								},
							},           -- options to pass into the `overseer.new_task` command
							on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
						},
						terminal = {
							name = "Main Terminal",
							prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
							split_direction = "horizontal", -- "horizontal", "vertical"
							split_size = 11,

							-- Window handling
							single_terminal_per_instance = true, -- Single viewport, multiple windows
							single_terminal_per_tab = true, -- Single viewport per tab
							keep_terminal_static_location = true, -- Static location of the viewport if avialable

							-- Running Tasks
							start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
							focus = false, -- Focus on terminal when cmake task is launched.
							do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
						},
					},
				},
				cmake_notifications = {
					runner = { enabled = true },
					executor = { enabled = true },
					spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
					refresh_rate_ms = 100, -- how often to iterate icons
				},
			})
		end,
	},
	{

		"lervag/vimtex",
		lazy = false,
		init = function()
			--global vimtex settings
			vim.g.vimtex_imaps_enabled = 0 --i.e., disable them
			--vimtex_view_settings
			vim.g.vimtex_view_method =
			"general" -- change this, depending on what you want to use..sumatraPDF, or skim, or zathura, or...
			-- vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
			--quickfix settings
			vim.g.vimtex_quickfix_open_on_warning = 0 --  don't open quickfix if there are only warnings
			vim.g.vimtex_quickfix_ignore_filters = {
				"Underfull",
				"Overfull",
				"LaTeX Warning: .\\+ float specifier changed to",
				"Package hyperref Warning: Token not allowed in a PDF string",
			}
			vim.g.tex_flavor = "latex"
		end,
	},
}
