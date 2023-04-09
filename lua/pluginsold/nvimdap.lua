local set = vim.keymap.set
set("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
set("n", "<leader>do", ":lua require'dap'.step_over()<CR>")
set("n", "<leader>di", ":lua require'dap'.step_into()<CR>")
set("n", "<leader>du", ":lua require'dap'.step_out()<CR>")
set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
set("n", "<leader>de", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition'))<CR>")
set("n", "<leader>dl", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message:'))<CR>")
set("n", "<leader>dr", ":lua require'dap'.repl.open()")
set("n", "<leader>dt", "echom 'Not setup for this filetype'")

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require("dapui").setup()
require("nvim-dap-virtual-text").setup()
