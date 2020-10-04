local M = {}

local rest_blocks = {}
local block = {}
local key = ""
local value = {}

-- TODO choose a better name
function update_block(insert)
  if key ~= "" then
    -- todo value should be a string not table
    block[key] = value
    key = ""
    value = {}
    if insert then
      table.insert(rest_blocks, block)
      block = {}
    end
  end
end

function M.parse_lines(buf_lines)
  for _,l in pairs(buf_lines) do
    if l == "" then
      update_block(true)
    else
      -- Captures rest call property name and argument
      -- Ignores whitespace at begining and end
      -- and before and after the : seperator
      local name, arg = l:match("^%s*(%S+)%s*:%s*(%S+)%s*$")
      if name then
        update_block(false)
        key = name
        table.insert(value, arg)
      else
        -- if no property name, then chck if argument is multiline
        local arg = l:match("^%s*\\%s*(.-)%s*$")
        if arg then
          table.insert(value, arg)
        end
      end
    end
  end
  update_block(true)

  return rest_blocks
end

return M
