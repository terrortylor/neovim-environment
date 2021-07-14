local api = vim.api

-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
-- api.nvim_buf_set_option(0, "undofile", true)
-- viml set option sets global and local: https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
vim.o.undofile = true
vim.bo.undofile = true

-- TODO implement "gf" for lua
local util = require("util.config")

vim.g.mapleader = " "

vim.g.markdown_fenced_languages = {"bash=sh", "sh", "ruby"}

-- Configurations
require("config.options")
require("config.autogroups")
require("config.mappings")
require("config.commands")
require("config.abbreviations")

-- Download and load my plugin manager if not on the path
local install_path = api.nvim_call_function("stdpath", {"data"}) .. "/site/pack/myplugins/start/nvim-pluginman"
local fs = require("util.filesystem")
if not fs.is_directory(install_path) then
  vim.cmd("!git clone https://github.com/terrortylor/nvim-pluginman " .. install_path)
  vim.cmd("packadd nvim-pluginman")
end
local plug = require("pluginman")
plug.setup()

-- colour shceme
require("plugins.tender")

-- comment toggler
require("plugins.nvim-comment")

-- http client
require("plugins.nvim-httpclient")

-- plugins for testing neovim
require("plugins.nvim-testing")

-- plug.add({url = "godlygeek/tabular", loaded = "opt"})
-- tabular needs to be sourced before vim-markdown
-- according to the repository site

plug.add("plasticboy/vim-markdown")
-- This is for plasticboy/vim-markdown
-- Don't require .md extension
vim.g.vim_markdown_no_extensions_in_markdown = 1

-- Autosave when following links
vim.g.vim_markdown_autowrite = 1
-- require("plugins.vim-markdown")

-- quick navigation around buffer
require("plugins.hop").setup()

-- trying to break some bad habbits
-- require("plugins.vim-hardtime").setup()

-- plug.add("AndrewRadev/switch.vim")

require("plugins.nvim-tree").setup()
require("plugins.telescope").setup()

-- TODO make optional, see init.vim so loads if python3
plug.add({
  url = "SirVer/ultisnips",
  post_handler = function()
    require("plugins.ultisnips")
  end
})

-- plug.add("fatih/vim-go")

  --plug.add({
  --url = "ludovicchabant/vim-gutentags",
  --post_handler = function()
  --  require("plugins.gutentags")
  --end
  --})

-- tmux/vim seamless window/pane navigation
require("plugins.tmuxnavigator")

-- add syntax colour to colours and colour codes in buffers
require("plugins.nvim-colorizer")

-- add git line status to signs column
require("plugins.gitsigns").setup()

-- plug.add("machakann/vim-sandwich")

-- Auto Pairs
-- plug.add("cohama/lexima.vim")
-- TODO handle for both cases? whats the effect of disabelling in lexima
vim.g.lexima_map_escape = ""

require("plugins.lsp")
require("plugins.treesitter")

-- run tests in a project at various levels
require("plugins.vim-test")

-- setup custom colour overrides
require("config.colour-overrides").setup()

plug.install()

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

