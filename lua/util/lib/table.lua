local M = {}

function M.find(table, val)
  for i,v in pairs(table) do
    if v == val then
      return i
    end
  end
  return -1
end

return M
