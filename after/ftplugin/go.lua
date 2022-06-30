local set = vim.keymap.set
set("n", "<leader>dt", ":lua require('dap-go').debug_test()<CR>")
