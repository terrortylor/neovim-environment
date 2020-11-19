local api = vim.api

local M = {}

local config_path = api.nvim_call_function('stdpath', {'data'})
local github_url = 'https://github.com/'
-- TODO how can this be passed in?
local default_package = 'plugins'

local function get_name(name)
  return name:match('/([%w_%-%.]+)$')
end

local function get_url(name)
  local url = ''
  if name:match('^http') or name:match('^www') then
    url = name
  else
    url = github_url .. name .. '.git'
  end
  return url
end

local function get_install_path(plugin)
  local package = default_package
  local opt = 'start'

  if plugin.package then
    package = plugin.package
  end

  if plugin.opt then
    opt = plugin.opt
  end

  local path = string.format('%s/site/pack/%s/%s/%s', config_path, package, opt, get_name(plugin.name))
  return path
end

-- TODO add tests
-- TODO should I pass in the plugin?
local function call_git(name, docs_path, args)
  -- print(vim.inspect(args))
  local handle

  local options = {
    args = args,
    -- Prevents prompts which we don't want to handle
    env = {"GIT_TERMINAL_PROMPT=0"}
  }

  local on_exit_cb = function(code, signal)
    if code == 0 then
      -- TODO better output...?
      print('Cloned plugin: ' .. name)
      if api.nvim_call_function('isdirectory', {docs_path}) > 0 then
        print('Docs found, generating helptags')
        api.nvim_command('helptags ' .. docs_path)
      end
    else
      print('Could not clone plugin: ' .. name .. ' code: ' .. code)
    end
    handle:close()
  end

  handle = vim.loop.spawn('git', options, vim.schedule_wrap( on_exit_cb))
end

local function exists(plugin)
  local path = get_install_path(plugin)
 if api.nvim_call_function('isdirectory', {path}) > 0 then
   return true
 else
   return false
 end
end

local function get_git_args(plugin)
  local args = {'clone', '--single-branch'}

  if plugin.branch then
    table.insert(args, '-b')
    table.insert(args, plugin.branch)
  end

  table.insert(args, get_url(plugin.name))

  table.insert(args, get_install_path(plugin))

  return args
end

-- TODO better name?
-- TODO add tests
function M.go(plugins)
  for _,plug in pairs(plugins) do
    if not exists(plug) then
      call_git(plug.name, get_install_path(plug) .. '/doc', get_git_args(plug))
    end
  end
end

if _TEST then
  M._get_name = get_name
  M._get_url = get_url
  M._get_install_path = get_install_path
  M._exists = exists
  M._get_git_args = get_git_args
end

return M
