-- TODO is this required? could i just use the nvim_out_write and nvim_error_write
local api = vim.api

local M = {}

LOG_LEVEL = "INFO"

local log_levels = {
  ERROR = { order = 0, hl = "ErrorMsg" },
  WARN = { order = 1, hl = "WarningMsg" },
  INFO = { order = 2, hl = "None" },
  DEBUG = { order = 3, hl = "None" },
}

function M.log_message(level, message)
  local log_level = log_levels[level]
  if not log_level then
    api.nvim_command("echohl ErrorMsg")
    api.nvim_command('echom "ERROR: Invalid log level: ' .. level .. '"')
    api.nvim_command("echohl None")
    return
  end

  local global_log_level = log_levels[LOG_LEVEL]
  if log_level.order <= global_log_level.order then
    api.nvim_command("echohl " .. log_level.hl)
    api.nvim_command('echom "' .. level .. ": " .. message .. '"')
    api.nvim_command("echohl None")
  end
end

-- Extend module to handle methods error, warn etc
-- that then wrap the log_message
setmetatable(M, {
  __index = function(self, k)
    local mt = getmetatable(self)
    local x = mt[k]
    if x then
      return x
    end
    -- create log level methods on the fly
    if log_levels[k:upper()] then
      local func = function(...)
        M.log_message(k:upper(), ...)
      end
      mt[k] = func
      return func
    end
  end,
})

return M
