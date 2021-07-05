local api = vim.api
local M = {}

local function create_func_stub(definition)
	local stub = ""

  return stub
end

function M.get_struct_name(struct)
  -- Split on whitespae, and get struct name
  return vim.fn.split(vim.trim(struct[2]), "\\s")[2]
end

local function slice(tbl, first, last)
  return {unpack(tbl, first, last)}
end

local function first_char(string)
  return string:sub(1,1):lower()
end

function M.get_func_arguments(func)
  -- match to get arg types
  -- split on , with optional space
  local args = vim.split(func:match("%a%((.-)%).+"), ",%s?")

  local argCount = {}

  local result = {}
    
  for _,arg in pairs(args) do
    local count = argCount[arg]
    if count then
      count = count + 1
    else
      count = 1
    end
    argCount[arg] = count

    local value = first_char(arg)
    if count > 1 then
      value = value .. count
    end

    table.insert(result, value .. " " .. arg)
  end

  return vim.fn.join(result, ", ")
end

function M.generate_implementation(interface, struct)
  local name = M.get_struct_name(struct)
  local receiver = first_char(name)
  local methods = slice(interface, 3, #interface - 1)
  local impl = {}

  for _,m in pairs(methods) do
    
  end

  return impl
end

function M.generate_constructor(struct)
  if M.action_chooser(struct) ~= "struct" then
    print("no struct found")
    return
  end

  local name = M.get_struct_name(struct)

  -- strips out struct property lines
  -- TODO candidate to move to utils as slice func?
  local properties = slice(struct, 3, #struct - 1)
  -- TODO choose which properties initialse
  local const_props = {}
  local stuct_props = {}
  for _, property in pairs(properties) do
    local parts = vim.split(vim.trim(property), '%s')
    local prop_name = parts[1]
    local prop_type = parts[2]
    table.insert(const_props, prop_name .. " " .. prop_type)
    table.insert(stuct_props, prop_name .. ": " .. prop_name)
  end
  return {
    "func New" .. name:gsub("^%l", string.upper) .. "(" .. vim.fn.join(const_props, ", ") .. ") {",
    "    return &" .. name .. "{" .. vim.fn.join(stuct_props, ", ") .. "}",
    "}"
  }
end

-- Given a definition, identify what it is
function M.action_chooser(definintion)
  if not definintion then
    print("no definintion passed")
    return
  end

  if #definintion < 2 then
    print("invalid definintion passed")
    return
  end

  if definintion[2]:match("^type%s(.*)%sinterface+") then
    return "interface"
  elseif definintion[2]:match("^type%s(.*)%sstruct+") then
    return "struct"
    -- local method_defs = {unpack(definintion, 3, #definintion - 2)}
    -- print("methods", vim.inspect(method_defs))
    -- for _,method  in ipairs(method_defs) do
    --   local trim_method = method:gsub("^%s+", "")
    --   -- print(trim_method)
    --   local stub = create_func_stub(trim_method)
    --   print("stub\n", stub)
    -- end
  else
    print("Not implemented")
  end
end

return M
