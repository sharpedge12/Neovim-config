return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			-- C++ adapter setup (cpptools)
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
			}
			dap.configurations.cpp = {

				{
					name = "Launch file",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = true,
					setupCommands = {
						{
							description = "Enable pretty-printing for gdb",
							text = "-enable-pretty-printing",
							ignoreFailures = false,
						},
					},
					MIMode = "gdb",
					miDebuggerPath = "/usr/bin/gdb", -- or your gdb path
					console = "externalTerminal", -- <--- This is the key line!
				},
			}
			-- Optionally, use the same config for C and C++
			dap.configurations.c = dap.configurations.cpp

			-- Keymaps
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Conditional Breakpoint" })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: Toggle UI" })
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			local dap = require("dap")
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			dap.adapters.python = {
				type = "executable",
				command = mason_path,
				args = { "-m", "debugpy.adapter" },
			}
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					console = "integratedTerminal",
					pythonPath = function()
						return vim.fn.exepath("python3") or "python3"
					end,
				},
			}
			vim.keymap.set("n", "<leader>dn", function()
				dap.continue()
			end, { desc = "Debug: Start/Continue" })
		end,
	},
}
