local M = {}

function M.find(table, val)
  for i, v in pairs(table) do
    if v == val then
      return i
    end
  end
  return -1
end

function M.dict_size(table)
  local count = 0
  if table then
    for _, _ in pairs(table) do
      count = count + 1
    end
  end
  return count
end

-- TODO add tests
-- TODO should handle if nils
function M.is_string_list_same(a, b)
  for i, a_v in pairs(a) do
    local b_v = b[i]
    if not b_v then
      return false
    end
    if a_v ~= b_v then
      return false
    end
  end
  return true
end

return M
