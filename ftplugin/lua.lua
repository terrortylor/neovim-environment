local opts = {noremap = true}
local function keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end

-- Run all tests
keymap("n", "<leader>gt", ":TestRunAll<CR>", opts)
