-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
-- api.nvim_buf_set_option(0, "undofile", true)
-- viml set option sets global and local: https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
vim.o.undofile = true
vim.bo.undofile = true

vim.g.mapleader = " "

-- Configurations
require("config.options")
require("config.autogroups")
require("config.mappings")
require("config.commands")
require("config.abbreviations")

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

require("config.plugins")

-- Custom Plugins
local plugins = {
  "git",
  "ui.arglist",
  "ui.tabline",
  "ui.statusline",
  "ui.search",
  "tmux",
  "alternate",
  -- "generator",
  "ui.switcheroo",
  "pa",
  -- "snake",
  "wiki",
  "util.auto_update",
}

for i,p in pairs(plugins) do
  require(p).setup()
end

