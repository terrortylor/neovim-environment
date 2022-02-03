vim.opt.spell = true
vim.opt.spelllang = { 'en_gb' }
-- vim.o.conceallevel = 2
-- vim.o.concealcursor = "nc"

local function keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end
keymap("i", "<C-b>", "*", {noremap = true})
