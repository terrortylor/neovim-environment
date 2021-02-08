local opts = {noremap = true}
local function keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end

-- Run all http requests in file
keymap("n", "<leader>gt", ":HttpclientRunFile<CR>", opts)
