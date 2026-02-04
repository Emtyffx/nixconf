return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- "rcarriga/nvim-dap-ui",
			-- {
			-- 	"jay-babu/mason-nvim-dap.nvim",
			-- 	opts = {
			-- 		ensure_installed = { "codelldb" },
			-- 	},
			-- },
			{
				"leoluz/nvim-dap-go",
				opts = {},
			},
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
				noremap = true,
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Toggle Conditional breakpoint",
				noremap = true,
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Run/Continue",
				noremap = true,
			},
			{
				"<leader>da",
				function()
					require("dap").continue({ before = require("utils").get_args })
				end,
				desc = "Run with args",
				noremap = true,
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to cursor",
				noremap = true,
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Goto line",
				noremap = true,
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step into",
				noremap = true,
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
				noremap = true,
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
				noremap = true,
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "",
				noremap = true,
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step out",
				noremap = true,
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step over",
				noremap = true,
			},
			{
				"<leader>dP",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
				noremap = true,
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "toggle REPL",
				noremap = true,
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
				noremap = true,
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
				noremap = true,
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
				noremap = true,
			},
		},
		config = function()
			local dap = require("dap")
			dap.adapters.codelldb = {
				type = "executable",
				command = "codelldb",
			}

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.rust = dap.configurations.cpp
			dap.configurations.c = dap.configurations.cpp
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		keys = {
			{
				"<leader>du",
				function()
					require("dapui").toggle({})
				end,
				desc = "Toggle Dap UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				desc = "Eval",
				mode = { "n", "v" },
			},
		},
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup(opts)
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
