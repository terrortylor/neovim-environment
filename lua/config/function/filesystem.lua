local filesystem = require("util.filesystem")
local api = vim.api

local M = {}

function M.delete_file(path)
  path = path or api.nvim_call_function("expand", {"%:p"})
  api.nvim_command("bwipeout! " .. path)
  filesystem.delete(path)
end

return M
