local api = vim.api

local M = {}

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

return M
