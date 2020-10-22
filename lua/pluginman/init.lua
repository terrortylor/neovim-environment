local source = require('pluginman.source')

local M = {}

local plugins = {}

function M.add(plugin)
  if type(plugin) == 'string' then
    local wrapped_p = {['name'] = plugin}
    table.insert(plugins, wrapped_p)
  elseif type(plugin) == 'table' then
    -- TODO nice to have fancy thing here where name doesn't have to have a key
    table.insert(plugins, plugin)
  end
end

-- TODO add tests
function M.install()
  source.go(plugins)
end

-- TODO remove
function M.get_plugins()
  return plugins
end

if _TEST then
  -- setup test alias for private elements using a modified name
  M._plugins = function() return plugins end
  M._reset = function() plugins = {} end
end

return M
