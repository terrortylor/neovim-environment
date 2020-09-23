-- TODO look at some pcall wrapping so everthing doesn't break if single error
local api = vim.api

-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
api.nvim_buf_set_option(0, "undofile", true)

-- TODO implement 'gf' for lua
local util = require('config.util')

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
require('config.plugin.ctrlp')
require('config.plugin.gutentags')
require('config.plugin.tmuxnavigator')
require('config.plugin.ultisnips')

-- Custom Plugins
require('git').setup()
require('tmux').setup()
require('alternate').setup()
