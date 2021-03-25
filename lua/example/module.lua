local M = {}

function M.realistic_func()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_command("sbuffer " .. buf)
end

return M
