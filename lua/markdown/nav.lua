local api = vim.api

local M = {}

function M.next_heading(direction)
  local search_term = api.nvim_command_output('echo @/')
  api.nvim_command(string.format('%s^#', direction))

  api.nvim_command(string.format('let @/ = "%s"', search_term))
end

return M
