local M = {}

-- TODO add tests
function M.file_exists(filename)
    local file = io.open(filename, "r")
    if (file) then
        file:close()
        return true
    end
    return false
end

return M
