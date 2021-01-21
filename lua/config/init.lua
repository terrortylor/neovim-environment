local api = vim.api

-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
api.nvim_buf_set_option(0, "undofile", true)

-- TODO implement "gf" for lua
local util = require("util.config")
local fs = require("util.filesystem")
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

-- Download and load my plugin manager if not on the path
local install_path = api.nvim_call_function("stdpath", {"data"}) .. "/site/pack/myplugins/start/nvim-pluginman"
if not fs.is_directory(install_path) then
  local execute = vim.api.nvim_command
  execute("!git clone https://github.com/terrortylor/nvim-pluginman " .. install_path)
  execute "packadd nvim-pluginman"
end

-- Plugins
plug.add({url = "godlygeek/tabular", loaded = "opt"})
-- tabular needs to be sourced before vim-markdown
-- according to the repository site
-- TODO make optional
plug.add("plasticboy/vim-markdown")
plug.add("justinmk/vim-sneak")

-- TODO make optional, and have 0.5.0 checked and load alternative if so
plug.add({
  url = "preservim/nerdtree",
  post_handler = function()
    require("config.plugin.nerdtree")
  end
})

plug.add({
  url = "junegunn/fzf.vim",
  post_handler = function()
    require("config.plugin.fzf")
  end
})

-- TODO make optional, see init.vim so loads if python3
plug.add({
  url = "SirVer/ultisnips",
  post_handler = function()
    require("config.plugin.ultisnips")
  end
})

plug.add("fatih/vim-go")

plug.add({
  url = "ludovicchabant/vim-gutentags",
  post_handler = function()
    require("config.plugin.gutentags")
  end
})

plug.add({
  url = "christoomey/vim-tmux-navigator",
  post_handler = function()
    require("config.plugin.tmuxnavigator")
  end
})

plug.add("jacoborus/tender.vim")
plug.add("udalov/kotlin-vim")
plug.add("machakann/vim-sandwich")
plug.add("PProvost/vim-ps1")

local has_lsp = api.nvim_call_function("has", {"nvim-0.5.0"})
if has_lsp == 1 then

  plug.add({ url = "neovim/nvim-lspconfig",
  post_handler = function()
    require("config.lsp")
  end
})
end

plug.install()

-- Custom Plugins
-- TODO setup is in init.lua... but then all dependencies are sourced
-- so maybe init.lua just set"s up what is required to get going like autoload vs plugin directory
local plugins = {
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
