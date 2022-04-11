local ag = vim.api.nvim_create_augroup("cursor_line_group", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "*",
  command = "setlocal cursorline",
  group = ag,
})
vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  command = "setlocal nocursorline",
  group = ag,
})

-- TODO move to another unit
ag = vim.api.nvim_create_augroup("line_numbers", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "*",
  command = "lua require('ui.window.numbering').win_enter()",
  group = ag,
})
vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  command = "lua require('ui.window.numbering').win_leave()",
  group = ag,
})
vim.api.nvim_create_autocmd("CmdLineEnter", {
  pattern = "*",
  command = "lua require('ui.window.numbering').cmd_enter()",
  group = ag,
})
vim.api.nvim_create_autocmd("CmdLineLeave", {
  pattern = "*",
  command = "lua require('ui.window.numbering').cmd_leave()",
  group = ag,
})

vim.api.nvim_create_autocmd("bufenter", {
  pattern = "*",
  command = "lua require('ui.buffer').move_to_last_edit()",
  group = vim.api.nvim_create_augroup("return_to_last_edit_in_buffer", { clear = true }),
})
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  command = "silent! lua vim.highlight.on_yank()",
  group = vim.api.nvim_create_augroup("highlight_on_yank", { clear = true }),
})
