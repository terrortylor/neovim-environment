-- luacheck: globals Plugin
require("pluginman.plugin")
local clone = require('pluginman.clone')
local view = require('pluginman.view')
local fs = require("util.filesystem")

-- TODO handle this better
local api = vim.api
local config_path = api.nvim_call_function('stdpath', {'data'})

local M = {}

local plugins = {}

function M.add(opts)
  local plugin
  if type(opts) == 'string' then
    plugin = Plugin:new(config_path, {url = opts})
  elseif type(opts) == 'table' then
    plugin = Plugin:new(config_path, opts)
  end
  table.insert(plugins, plugin)
end

function M.check_plugin_status(plugin)
  if fs.is_directory(plugin:get_install_path()) then
    plugin:set_installed(true)
    if fs.is_directory(plugin:get_docs_path()) then
      plugin:set_docs(true)
    else
      plugin:set_docs(false)
    end
    return false
  else
    return true
  end
end

-- TODO add tests
function M.install()
  local require_install = false
  -- check if any plugins or docs need generating
  for _,plug in pairs(plugins) do
    local missing = M.check_plugin_status(plug)
    if missing then
      require_install = true
      break
    end
  end

  -- install/clone if required
  if require_install then
    M.open_summary_draw()

    for _,plug in pairs(plugins) do
      clone.get(plug, view.summary)
    end
  end
end

-- TODO add tests
function M.open_summary_draw()
  view.set_plugins(plugins)
  view.summary()
end

function M.setup()
  local command = {
    "command!",
    "-nargs=0",
    "PluginsStatus",
    "lua require('pluginman').open_summary_draw()"
  }
  api.nvim_command(table.concat(command, ' '))
end


if _TEST then
  -- setup test alias for private elements using a modified name
  M._plugins = function() return plugins end
  M._reset = function() plugins = {} end
end

return M
