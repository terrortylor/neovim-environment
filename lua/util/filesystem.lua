local api = vim.api
local log  = require("util.log")

local M = {}

--- Creates a directory, linux only
-- @param path string the path to create, if nil then uses path of current buffer
function M.mkdir(path)
  path = path or api.nvim_call_function("expand", {"%:p:h"})
  os.execute("mkdir -p " .. path)
end

-- TODO remove this in favoure of just calling vim function
function M.file_exists(filename)
    local file = io.open(filename, "r")
    if (file) then
        file:close()
        return true
    end
    return false
end

--- Wrapper to truthy and pretify
--@param path string - directory path to check
--@return boolean true if exists, false if not
function M.is_directory(path)
 if api.nvim_call_function('isdirectory', {path}) > 0 then
   return true
 else
   return false
 end
end

--- Wrapper to truthy and pretify
--@param path string - directory path to check
--@return boolean true if exists, false if not
function M.is_file(path)
 if api.nvim_call_function('filereadable', {path}) > 0 then
   return true
 else
   return false
 end
end

function M.delete(path)
  if M.is_directory(path) then
    log.error("Delete directory not supported")
    return
  end
  if not M.is_file(path) then
    log.error("File not found or not readable")
    return
  end
  os.execute("rm " ..  path)
  if M.is_file(path) then
    log.error("File not deleted, still present on disk!")
  end
end

return M
