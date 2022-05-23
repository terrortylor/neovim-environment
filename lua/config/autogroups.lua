local ag = vim.api.nvim_create_augroup("push_notes", { clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*/personal-workspace/notes/*",
  command = "!~/personal-workspace/notes/push.sh",
  group = ag,
})

ag = vim.api.nvim_create_augroup("cursor_line_group", { clear = true })
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

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local exit_loc = vim.api.nvim_buf_get_mark(0, '"')
    local last_line = vim.api.nvim_buf_line_count(0)

    if exit_loc[1] > 0 and exit_loc[1] <= last_line then
      local w_id = vim.api.nvim_tabpage_get_win(0)
      vim.api.nvim_win_set_cursor(w_id, exit_loc)
      -- Open fold and center
      vim.api.nvim_input("zvzz")
    end
  end,
  group = vim.api.nvim_create_augroup("return_to_last_edit_in_buffer", { clear = true }),
})

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  command = "silent! lua vim.highlight.on_yank()",
  group = vim.api.nvim_create_augroup("highlight_on_yank", { clear = true }),
})
