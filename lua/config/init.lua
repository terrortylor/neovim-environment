local api = vim.api

-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
api.nvim_buf_set_option(0, "undofile", true)

-- TODO implement "gf" for lua
local util = require("util.config")
local plug = require("pluginman")

api.nvim_set_var("mapleader", " ")

local global_variables = {
  markdown_fenced_languages = {"bash=sh", "sh", "ruby"}
}

util.set_variables(global_variables)

-- Configurations
require("config.options")
require("config.autogroups")
require("config.mappings")
require("config.commands")
require("config.abbreviations")

-- Plugins
-- TODO make optional
plug.add("godlygeek/tabular")
-- tabular needs to be sourced before vim-markdown
-- according to the repository site
-- TODO make optional
plug.add("plasticboy/vim-markdown")
plug.add("justinmk/vim-sneak")

-- TODO make optional, and have 0.5.0 checked and load alternative if so
plug.add("preservim/nerdtree")
require("config.plugin.nerdtree")

plug.add("junegunn/fzf.vim")
require("config.plugin.fzf")

-- TODO make optional, see init.vim so loads if python3
plug.add("SirVer/ultisnips")
require("config.plugin.ultisnips")

plug.add("fatih/vim-go")

plug.add("ludovicchabant/vim-gutentags")
require("config.plugin.gutentags")

plug.add("christoomey/vim-tmux-navigator")
require("config.plugin.tmuxnavigator")

plug.add("jacoborus/tender.vim")
plug.add("udalov/kotlin-vim")
plug.add("machakann/vim-sandwich")
plug.add("PProvost/vim-ps1")

local has_lsp = api.nvim_call_function("has", {"nvim-0.5.0"})
if has_lsp == 1 then
  plug.add("neovim/nvim-lspconfig")
end

plug.install()

if has_lsp == 1 then
  require("config.lsp")
end

-- Custom Plugins
-- TODO setup is in init.lua... but then all dependencies are sourced
-- so maybe init.lua just set"s up what is required to get going like autoload vs plugin directory
local plugins = {
  "pluginman",
  "git",
  "ui.buffer.comment",
  "ui.arglist",
  "tmux",
  "alternate",
  "pa",
  "snake",
  "wiki",
  "fzf",
  "test"
}

for i =1, #plugins do
  require(plugins[i]).setup()
end

require("config.plugin.httpclient")
