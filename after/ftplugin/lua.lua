local function keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end
local opts = {noremap = true}
keymap("n", "<leader>gtf", "<Plug>PlenaryTestFile", opts)
keymap("n", "<leader>gtt", "<Plug>PlenaryTestFile", opts)

