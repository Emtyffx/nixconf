return {
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			{
				"leoluz/nvim-dap-go",
				opts = {},
			},
		},
		keys = {
			{
				"<F4>",
				function()
					require("dapui").toggle()
				end,
				mode = "n",
				desc = "[DAP]: Toggle",
			},
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				mode = "n",
				desc = "[DAP]: Continue",
			},
			{
				"<leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				mode = "n",
				desc = "[DAP]: Toggle [b]reakpoint",
			},
			{
				"<leader>B",
				function()
					require("dap").set_breakpoint()
				end,
				mode = "n",
				desc = "[DAP]: Set [B]reakpoint",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				mode = "n",
				desc = "[D]AP: Step [I]nto",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				mode = "n",
				desc = "[D]AP: Step [O]ut",
			},
			{
				"<leader>dv",
				function()
					require("dap").step_over()
				end,
				mode = "n",
				desc = "[D]AP: Step O[v]er",
			},
			{
				"<leader>dp",
				function()
					require("dap").pause()
				end,
				mode = "n",
				desc = "[D]AP: [P]ause",
			},
			{
				"<leader>db",
				function()
					require("dap").step_back()
				end,
				mode = "n",
				desc = "[D]AP: Step [B]ack",
			},
		},
		config = function()
			require("dapui").setup()
			local dap, dapui = require("dap"), require("dapui")
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

			-- configure dap
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
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp
		end,
	},
}
