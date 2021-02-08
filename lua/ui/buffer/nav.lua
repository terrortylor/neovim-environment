local api = vim.api

local M = {}

function M.find_next(direction, search_value)
  local search_term = api.nvim_command_output('echo @/')
  api.nvim_command(string.format('execute "normal %s%s\\<CR>"', direction, search_value))

  api.nvim_command(string.format('let @/ = "%s"', search_term))
end

return M
