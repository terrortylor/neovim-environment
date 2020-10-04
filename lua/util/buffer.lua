local api = vim.api
local M = {}

-- TODO add tests
function M.get_buf_id(file)
  local buf = api.nvim_call_function("bufnr", {file})
  return buf
end

return M
