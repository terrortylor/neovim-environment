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

return M
