local float = require("plenary.window.float")


local res = float.percentage_range_window(.5, .5, {}, {})
local lines = {
  "this is a test",
  "this is a test",
}
vim.api.nvim_buf_set_lines(res.bufnr, 0, 1, false, lines)
vim.keymap.set("n", "q", ":bd!<CR>", { buffer = res.bufnr })
vim.keymap.set("n", "<ESC>", ":bd!<CR>", { buffer = res.bufnr })
