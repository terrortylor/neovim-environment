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

-- require('packer').init({config = {
--   profile = {
--     enable = false,
--     threshold = 1 -- the amount in ms that a plugins load time must be over for it to be included in the profile
--   }
-- }})

-- Custom Plugins
local plugins = {
  "git.blame",
  "ui.arglist",
  "ui.tabline",
  "ui.statusline",
  -- "ui.search",
  -- "ui.splash",
  "tmux",
  "alternate",
  "ui.switcheroo",
  "pa",
  "snake",
  "util.auto_update",
}

for _,p in pairs(plugins) do
  require(p).setup()
end
