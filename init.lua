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
require("config.external-plugins")

-- Custom Plugins
local plugins = {
  "git",
  "ui.arglist",
  "ui.tabline",
  "ui.statusline",
  "tmux",
  "alternate",
  "pa",
  "snake",
  "wiki",
  "util.auto_update",
}

for i = 1, #plugins do
  require(plugins[i]).setup()
end

