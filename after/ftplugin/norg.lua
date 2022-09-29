vim.opt.spell = true
vim.opt.spelllang = { "en_gb" }
-- vim.o.conceallevel = 2
-- vim.o.concealcursor = "nc"

local set = vim.keymap.set
set("i", "<C-b>", "*", { buffer = true })
set("n", "<leader>ff", ":Telescope neorg find_linkable<CR>", { buffer = true })

set("n", "[g", function()
  require("ui.buffer.nav").find_next("?", [[^\\s\\+-\\+\\s\[.\\]\\s]])
end, { desc = "Go to previous gtd task"})
set("n", "]g", function()
  require("ui.buffer.nav").find_next("/", [[^\\s\\+-\\+\\s\[.\\]\\s]])
end, { desc = "Go to next gtd task"})

-- TODO cheap indentation, could be much better with context awareness
set("n", ">", function()
  require("neorgtools.indent").indent()
end, { desc = "Indent Line Right" })
set("n", "<", function()
  require("neorgtools.indent").dedent()
end, { desc = "Indent Line Left" })

-- TODO be nice to have a script that in a given file, looks for `Terminology`
-- heading and then updates all references to be links, see `tech/iso27001.norg`

-- add hook to nvim tree rename
-- TODO move to setup call in module, and add filetype check
require("neorgtools").nvimTreeRenameEventHook()

-- Don't spell check URL's
-- https://vi.stackexchange.com/questions/3990/ignore-urls-and-email-addresses-in-spell-file
-- vim.cmd("syn match UrlNoSpell '\w\+:%/\/[^[:space:]]\+' contains=@NoSpell")
