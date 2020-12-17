-- luacheck: globals Request
require'restclient.request'
local s_util = require'util.string'

local M = {}

-- TODO change scope to be in parse func
local requests
local variables = {}

local function reset()
  requests = {}
  variables = {}
end

local function add_request(request)
  if request and request.url then
    table.insert(requests, request)
  end
end

local function is_url(s)
  if s:match('^http[s]?://') then
    return true
  elseif s:match('^www.') then
    return true
  elseif s:match('(.*)%.(.*)$') then
    return true
  end
  return false
end

function M.parse_lines(buf_lines)
  reset()
  local req = Request:new(nil)

-- TODO add json block support
-- TODO special json headers
  for _,l in pairs(buf_lines) do
    -- matches a comment
    if l:match('^%s*#') then
      goto skip_to_next_line
    -- matches if to use skip ssl flag
    elseif l:match('^skipSSL$') then
      req.skipSSL = true
      -- match variable
    elseif l:match("^var%s+(.*)[=:](.*)") then
      local key, value = l:match("^var%s+(.*)[=:](.*)")
      variables[key] = value
      -- matches url
    elseif is_url(l) then
      req.url = l
      -- matches verb and path
    elseif l:match('^%a+%s[%a%d/_-]+') then
      local verb, path = l:match('(.*)%s(.*)')
      req.verb = verb
      req.path = path
      -- matches headers
    elseif l:match('^H[EADER]*[=:].*[=:]') then
      local key,value = l:match('^H[EADER]*[=:](.*)[=:](.*)')
      req:add_header(key, s_util.trim_whitespace(value))
      -- Matches data key value pairs
    elseif l:match('^(.*)[=:](.*)$') then
      local key,value = l:match('(.*)[=:](.*)')
      req:add_data(key, value)
      -- match file for data
    elseif l:match('^%@') then
      req.data_filename = l
    elseif l:match('^%s*$') then
      add_request(req)
      req = Request:new(nil)
    end
    ::skip_to_next_line::
  end
  add_request(req)

  return requests, variables
end

if _TEST then
  M._reset = reset
  M._add_request = add_request
  M._get_requests = function() return requests end
end

return M
