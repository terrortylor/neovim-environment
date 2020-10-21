local M = {}

function M.find(table, val)
  for i,v in pairs(table) do
    if v == val then
      return i
    end
  end
  return -1
end

function M.dict_size(table)
  local count = 0
  if table then
    for _,_ in pairs(table) do
      count = count + 1
    end
  end
  return count
end

--- Lifted straight from: http://lua-users.org/wiki/CopyTable
function M.shallow_copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return M