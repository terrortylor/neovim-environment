-- luacheck: globals Request

local NONE = 0
local RUNNING = 1
local MISSING_DATA = 2
local DONE = 3
local ERROR = 4

-- Meta class
Request = {
  url = nil,
  verb = nil,
  path = nil,
  data = nil,
  data_filename = nil,
  result = nil,
  headers = nil,
  extract = nil,
  skipSSL = false,
  response = nil,
  state = NONE
}

-- should these be set via getters?
function Request:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   -- Tables have to be initialised
   o.data = {}
   o.headers = {}
   o.extract = {}
   -- self.result = {}
   return o
end

-- TODO Add tests
-- can be used to format? maybe user differnet classes?
function Request:get_results()
  local result_lines = {}
  if self.result then
    local vals = vim.split(self.result, "\n")
    for _, d in pairs(vals) do
      if d ~= "" then
        table.insert(result_lines, d)
      end
    end
  end
  return result_lines
end

function Request:add_data(key, value)
  self.data[key] = value
end

function Request:add_extract(key, value)
  self.extract[key] = value
end

function Request:get_extracted_values()
  local t = {}

  if not self.extract then
    return
  end

  local json = vim.api.nvim_call_function("json_decode", {self.result})

  local extract = function(path)
    local chunk = "return function() return json." .. path .. " end"
    local func, err = load(chunk, nil, "t", {json = json})
    if func then
      local ok, add = pcall(func)
      if ok then
        return add()
      else
        -- TODO better handling of this error
        print("Execution error:", add)
      end
    else
        -- TODO better handling of this error
      print("Compilation error:", err)
    end
    return nil
  end

  for k,v in pairs(self.extract) do
    local value = extract(v)
    t[k] = value
  end

  return t
end

function Request:add_header(key, value)
  self.headers[key] = value
end

function Request:get_title()
  local verb = 'GET'
  if self.verb then
    verb = self.verb
  end
  return verb .. " - " .. self.url
end

function Request:get_data(variables)
  self.state = NONE
  -- TODO can remove coplete_data as tracked in state
  local complete_data = true

  local var_sub = function(value)
    local var = value:match("^@(.*)@$")
    if var then
      if variables[var] then
        return variables[var]
      else
        self.state = MISSING_DATA
        complete_data = false
      end
    end
    return value
  end

  local data_string = ''
  if self.data_filename then
    return self.data_filename
  elseif self.data then
--    print("building data string")
    -- data is key/value pairs
    for k,v in pairs(self.data) do
      local key = var_sub(k)
      local value = var_sub(v)
      data_string = data_string .. string.format('%s=%s&', key, value)
      if not complete_data then
        return complete_data, nil
      end
    end
    -- trim remaining &
    if data_string:match("&$") then
      data_string = data_string:sub(1, -2)
    end
  end
  return complete_data, data_string
end

function Request:get_url()
  local url = self.url
  if self.path then
    if self.path:match('^/') then
      url = url .. self.path
    else
      url = url .. '/' .. self.path
    end
  end
  return url
end

-- TODO add test
function Request:set_running()
  self.state = RUNNING
end

-- TODO add test
function Request:is_running()
  return self.state == RUNNING
end

-- TODO add test
function Request:set_done()
  self.state = DONE
end

-- TODO add test
function Request:set_failed()
  self.state = ERROR
end

-- TODO add test
function Request:is_done()
  return self.state == DONE
end

-- TODO add test
function Request:is_queued()
  return self.state == NONE
end

function Request:is_missing_data()
  return self.state == MISSING_DATA
end

-- TODO spawn takes arguments, so is it worth building this as string? probably not!
function Request:get_curl(variables)
  -- get all the parts
  local verb = 'GET'
  if self.verb then
    verb = self.verb
  end

--  print("about to getdata")
  local success, data = self:get_data(variables)
  if not success then
    return nil
  end

  local url = self:get_url()

  -- start to build curl command
  -- TODO wrap url in double quotes
  local curl = string.format('-X %s %s', verb, url)

  -- are there query parameters to add
  -- TODO rather than POST, check for GET or DELETE
  -- TODO no handling of PATCH
  if data ~= '' then
    if verb == "POST" or verb == "PUT" then
      curl = string.format('%s --data %s', curl, data)
    else
      curl = string.format('%s?%s', curl, data)
    end
  end
  return curl
end
