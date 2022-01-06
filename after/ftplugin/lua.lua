local function keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end
keymap("n", "<leader>gtf", "<cmd> wall <cr> | <Plug>PlenaryTestFile", {})
keymap("n", "<leader>gtt", "<cmd> wall <cr> | <Plug>PlenaryTestFile", {})

