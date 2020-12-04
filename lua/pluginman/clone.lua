local api = vim.api
local fs = require("util.filesystem")

local M = {}

local function get_git_args(plugin)
  local args = {'clone', '--single-branch'}

  table.insert(args, '-b')
  table.insert(args, plugin:get_branch())

  table.insert(args, plugin:get_url())

  table.insert(args, plugin:get_install_path())

  return args
end

local function clone(plugin, callback)
  local docs_path = plugin:get_install_path()
  local args = get_git_args(plugin)
  -- print(vim.inspect(args))
  local handle

  local options = {
    args = args,
    -- Prevents prompts which we don't want to handle
    env = {"GIT_TERMINAL_PROMPT=0"}
  }

  local on_exit_cb = function(code, _)
    if code == 0 then
      plugin:set_installed(true)
      if fs.is_directory(docs_path) then
        api.nvim_command('helptags ' .. docs_path)
        plugin:set_docs(true)
      else
        plugin:set_docs(false)
      end
    else
      plugin:set_installed(false)
      plugin:set_install_error(true)
    end
    handle:close()

    callback()
  end

  handle = vim.loop.spawn('git', options, vim.schedule_wrap( on_exit_cb))
end

function M.get(plugin, callback)
  if not plugin then
    return
  end

  if not fs.is_directory(plugin:get_install_path()) then
    clone(plugin, callback)
  end
end

return M
