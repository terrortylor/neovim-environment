local api = vim.api
local M = {}

function M.get_all_lines(buf)
  return api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf), false)
end

-- TODO add tests
function M.get_buf_id(file)
  local buf = api.nvim_call_function("bufnr", {file})
  return buf
end

return M
