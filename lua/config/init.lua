local api = vim.api

-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
api.nvim_buf_set_option(0, "undofile", true)

-- Safe require... a little expensive though
local function p_require(module) -- luacheck: ignore
  local result, return_module = pcall(function() require(module) end)
  if not result then
    print("Unable to load config file: " .. module)
  end
  return return_module
end

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
plug.install()

-- Custom Plugins
-- TODO setup is in init.lua... but then all dependencies are sourced
-- so maybe init.lua just set"s up what is required to get going like autoload vs plugin directory
require("pluginman").setup()
require("git").setup()
require("ui.buffer.comment").setup()
require("ui.arglist").setup()
require("tmux").setup()
require("alternate").setup()
require("pa").setup()
require("snake").setup()
require("restclient").setup()
require("wiki").setup()
require("fzf").setup()
