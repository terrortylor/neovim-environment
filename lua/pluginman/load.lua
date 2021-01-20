local api = vim.api

local M = {}

function M.add_to_runtimepath(path)
  api.nvim_command("set runtimepath^=" .. path)
end

return M
