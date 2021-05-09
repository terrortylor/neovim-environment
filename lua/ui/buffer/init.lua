local api = vim.api

local M = {}

function M.new_line_no_comment(insert_above)
  local line,_ = unpack(api.nvim_win_get_cursor(0))
  if insert_above then
    api.nvim_buf_set_lines(0, line - 1, line - 1, 0, {""})
  else
    api.nvim_buf_set_lines(0, line, line, 0, {""})
  end
end

function M.prototype()
  -- backup a reg pos
  local orig_mark = api.nvim_buf_get_mark(0, "a")

  -- pcall to wrap an issues so can reset command like a final block
  -- as calling external plugin
  local _,_ = pcall(function()
    -- Reselect, copy to a reg, move to end of selection, put and reselect
    vim.cmd("normal! gv\"ay`>\"apgv")
    -- Comment out using comment toggle: https://github.com/terrortylor/nvim-comment
    vim.cmd("'<,'>CommentToggle")
    -- move to start of selection and down and start of line
    vim.cmd("normal! `>j0")
  end)

  -- lua seems to remain in visual mode
  api.nvim_input("<ESC>")
  -- restore a reg pos
  api.nvim_call_function("setpos", {"'a", {0, orig_mark[1], orig_mark[2], 0}})
end

return M
