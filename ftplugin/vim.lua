vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "FoldVimFunctions(v:lnum)"
vim.bo.iskeyword = vim.bo.iskeyword .. ",:"

local function keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end
local opts = {noremap = true}

-- declare rough text-objects for vim functions
-- fixme this operator pending doesn't work, \r probably needs to be escaped
keymap("o", "af", ':<c-u>execute "normal! ?^function\rv/^endfunction\r$"<cr>', opts)
keymap("x", "af", "?^function<cr>o/^endfunction<cr>$", opts)

	-- echo's selection on line bellow
keymap("x", "<leader>ev", "yoechom '<c-r>\": ' . <c-r>\"<esc>", opts)
