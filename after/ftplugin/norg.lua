vim.opt.spell = true
vim.opt.spelllang = { 'en_gb' }
-- vim.o.conceallevel = 2
-- vim.o.concealcursor = "nc"

local set = vim.keymap.set
set("i", "<C-b>", "*", {buffer = true})
set("n", "<leader>ff", ":Telescope neorg find_linkable<CR>", {buffer = true})

-- add hook to nvim tree rename
-- TODO move to setup call in module, and add filetype check
require("neorgtools").nvimTreeRenameEventHook()

-- Don't spell check URL's
-- https://vi.stackexchange.com/questions/3990/ignore-urls-and-email-addresses-in-spell-file
-- vim.cmd("syn match UrlNoSpell '\w\+:%/\/[^[:space:]]\+' contains=@NoSpell")
