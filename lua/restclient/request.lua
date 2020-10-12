local api = vim.api
-- TODO is log required?
local log = require('util.log')

-- Meta class
Request = {
  url = nil,
  verb = 'GET',
  data = nil,
  response = nil
}

-- should these be set via getters?
function Request:new(o, url)
   o = o or {}
   o.url = url
   setmetatable(o, self)
   self.__index = self
   return o
end

function Request:get_title()
  return self.verb .. " - " .. self.url
end

function Request:on_read_callback(err, data)
  self.response = {}
  if err then
    -- print('ERROR: ', err)
    -- TODO handle err
    table.insert(self.response, "Error")
  end
  if data then
    local vals = vim.split(data, "\n")
    for _, d in pairs(vals) do
      if d == "" then goto continue end
      table.insert(self.response, d)
      ::continue::
    end
  end
end

local function on_read_callback(err, data)
  self.response = {}
  if err then
    -- print('ERROR: ', err)
    -- TODO handle err
    table.insert(self.response, "Error")
  end
  if data then
    local vals = vim.split(data, "\n")
    for _, d in pairs(vals) do
      if d == "" then goto continue end
      table.insert(self.response, d)
      ::continue::
    end
  end
end

function Request:run(on_complete_callback)
  -- local curl_args = builder.build_curl(rest)
  -- local curl_args = {
  --   '-X',
  --   self.verb,
  --   self.url
  -- }
  local curl_args = '-X ' .. self.verb .. " " .. self.url

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  log.debug("Running cUrl: curl " .. curl_args)
  -- log.debug(vim.inspect(vim.split(curl_args, ' ')))

  local handle
  handle = vim.loop.spawn('curl', {
      args = vim.split(curl_args, ' '),
      stdio = {stdout,stderr}
    },
    vim.schedule_wrap(function()
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        handle:close()

        on_complete_callback() 
      end
    )
  )
  vim.loop.read_start(stdout, self:on_read_callback)
  vim.loop.read_start(stderr, self:on_read_callback)
end


-- function Request:draw()
--   self:close_window(self.win_id)
--   self:create_window()
-- end
