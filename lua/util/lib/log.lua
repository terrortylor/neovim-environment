local table = require('util.lib.table')
local M = {}

LOG_LEVEL = "ERROR"

local log_levels = {
  "ERROR",
  "WARN",
  "INFO",
  "DEBUG",
}

function M.log_message(level, message)
  local log_level = table.find(log_levels, level)
  if log_level < 0 then
    print("ERROR: Invalid log level: " .. level)
    return
  end

  local global_log_level = table.find(log_levels, LOG_LEVEL)
  if log_level <= global_log_level then
    print(level .. ": " .. message)
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
      if table.find(log_levels, k:upper()) then
        local func = function(...) M.log_message(k:upper(), ...) end
        mt[k] = func
        return func
      end
    end
})

return M
