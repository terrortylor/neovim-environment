require("hop").setup({
  keys = "etovxdygfblzhckisuran",
})

vim.api.nvim_set_keymap("n", "<leader>fj", ":HopWord<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>jj", ":HopChar1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>/", ":HopPattern<CR>", { noremap = true, silent = true })

-- Playing with f/F replacement
vim.api.nvim_set_keymap("n", "<leader>jf", "<cmd>lua require'hop'.hint_char1({ current_line_only = true })<cr>", {})

-- TODO hop with callback that then runs go to definition, or other LSP bits and bobs
