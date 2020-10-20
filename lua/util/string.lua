local M = {}

function M.trim_whitespace(s)
  return s:match("^%s*(.-)%s*$")
end

return M
