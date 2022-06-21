-- TODO change to vim.keymap.set? search for other occourances
local function keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end
keymap("n", "<leader>gtf", "<cmd>lua require('plugins.vim-test').lua_test_file()<cr>", {})
keymap("n", "<leader>gtt", "<cmd>lua require('plugins.vim-test').lua_test_last()<cr>", {})

