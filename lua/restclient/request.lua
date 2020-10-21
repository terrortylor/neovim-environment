-- Meta class
Request = {
  url = nil,
  verb = nil,
  path = nil,
  data = nil,
  data_filename = nil,
  headers = nil,
  skipSSL = false,
  response = nil
}

-- should these be set via getters?
function Request:new(o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self

   -- Tables have to be initialised
   self.data = {}
   self.headers = {}
   return o
end

function Request:add_data(key, value)
  self.data[key] = value
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

function Request:get_data()
  local data_string = ''
  if self.data_filename then
    return self.data_filename
  elseif self.data then
    -- data is key/value pairs
    for k,v in pairs(self.data) do
      data_string = data_string .. string.format('%s=%s&', k, v)
    end
    -- trim remaining &
    if data_string:match("&$") then
      data_string = data_string:sub(1, -2)
    end
  end
  return data_string
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

function Request:get_curl()
  -- get all the parts
  local verb = 'GET'
  if self.verb then
    verb = self.verb
  end
  local data = self:get_data()
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
