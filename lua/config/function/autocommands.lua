local api = vim.api

local M = {}

function M.move_to_last_edit()
  local exit_loc = api.nvim_buf_get_mark(0, "\"")
  local last_line = api.nvim_buf_line_count(0)

  if exit_loc[2] > 0 and exit_loc[2] <= last_line then
    local w_id = api.nvim_tabpage_get_win(0)
    api.nvim_win_set_cursor(w_id, exit_loc)
    -- Open fold and center
    api.nvim_input("zvzz")
  end
end

return M
