local opts = {noremap = true}
local function keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end

-- TODO this almost same line is in ftplugin/vim.lua can this be a plugin, e operator? echo in word?
-- echo's selection on line bellow
keymap("x", "<leader>ev", "yoecho \"<c-r>\": ${<c-r>\"}\"<esc>", opts)
