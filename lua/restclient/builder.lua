local M = {}

local function get_url(config)
  local url = config['url']
  if not url then
    error("URL must be provided")
  end

  return url[1]
end

local function get_verb(config)
  local verb = config['verb']
  if verb then
    return string.upper(verb[1])
  else
    return "GET"
  end
end

-- TODO
-- only supports key=value parameters
local function get_data(config, is_query)
  local data_string = ""
  local data = config['data']
  if data then
    -- has external file been referenced
    if data[1]:match("^@") then
      -- FIXME order here can be improved, as this is never going to happen if_query is true
      return data[1]
    else
      -- data is key/value pairs
      for _,v in pairs(data) do
        data_string = string.format('%s&%s', v, data_string)
      end
      -- trim remaining &
      if data_string:match("&$") then
        data_string = data_string:sub(1, -2)
      end
    end
  end
  return data_string
end

-- TODO builder funcs
-- basic auth
-- connect timeout
-- data query params / filename (use url-encode option)
-- form, overrides data
-- verb
-- headers
-- follow redirects / max-redirects?
-- output filename
-- allow insecure (--insecure)

function M.build_curl(config)
  -- get all the parts
  local verb = get_verb(config)
  local data = get_data(config)
  local url = get_url(config)

  -- start to build curl command
  local curl = string.format('-X %s %s', verb, url)

  -- are there query parameters to add
  -- TODO rather than POST, check for GET or DELETE
  if verb == "POST" or verb == "PUT" then
    if data ~= "" then
      curl = string.format('%s --data %s', curl, data)
    end
  else
    curl = string.format('%s?%s', curl, data)
  end
  return curl
end

if _TEST then
  M._get_url = get_url
  M._get_verb = get_verb
  M._get_data = get_data
end

return M
