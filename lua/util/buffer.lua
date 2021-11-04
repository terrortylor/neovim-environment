local api = vim.api
local M = {}

function M.get_all_lines(buf)
  return api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
end

-- TODO add tests
-- TODO is this still required? is it not in the api?
function M.get_buf_id(file)
  local buf = api.nvim_call_function("bufnr", {file})
  return buf
end

function M.run_and_back_to_mark(command)
  local mark = vim.api.nvim_win_get_cursor(0)
  vim.cmd(command)
  vim.api.nvim_win_set_cursor(0, mark)
end

return M
