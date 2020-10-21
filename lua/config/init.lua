local api = vim.api

-- Safe require... a little expensive though
local function p_require(module)
  local result, return_module = pcall(function() require(module) end)
  if not result then
    print("Unable to load config file: " .. module)
  end
  return return_module
end

-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
api.nvim_buf_set_option(0, "undofile", true)

-- TODO implement 'gf' for lua
local util = require('util.config')

api.nvim_set_var("mapleader", " ")

local global_variables = {
  markdown_fenced_languages = {'bash=sh', 'sh', 'ruby'}
}

util.set_variables(global_variables)

-- Configurations
require('config.options')
require('config.autogroups')
require('config.mappings')
require('config.commands')
require('config.abbreviations')

-- Plugins
require('config.plugin.nerdtree')
require('config.plugin.fzf')
require('config.plugin.gutentags')
require('config.plugin.tmuxnavigator')
require('config.plugin.ultisnips')

-- Custom Plugins
-- TODO setup is in init.lua... but then all dependencies are sourced
-- so maybe init.lua just set's up what is required to get going like autoload vs plugin directory
require('git').setup()
require('tmux').setup()
require('alternate').setup()
require('pa').setup()
require('snake').setup()
require('restclient').setup()
