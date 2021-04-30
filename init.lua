local api = vim.api

-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
-- api.nvim_buf_set_option(0, "undofile", true)
vim.bo.undofile = true

-- TODO implement "gf" for lua
local util = require("util.config")
local fs = require("util.filesystem")

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
local plug = require("pluginman")

--   plug.add("tjdevries/colorbuddy.nvim")

  -- plug.add({
  --   url = "terrortylor/nvim-tender",
  --   package = "myplugins",
  --   post_handler = function()
  --     -- require('nvim-tender')
  --    -- vim.api.nvim_command("colorscheme nvim-tender")
  --   end
  -- })

  plug.add({
    url = "jacoborus/tender.vim",
    post_handler = function()
      vim.api.nvim_command("colorscheme tender")
    end
  })


require("config.plugin.nvim-comment")
require("config.plugin.nvim-httpclient")
require("config.plugin.nvim-testing")

-- plug.add({
--   url = "terrortylor/nvim-httpclient",
--   -- branch = "main",
--   loaded = "opt",
--   package = "myplugins",
-- })

-- plug.add({url = "godlygeek/tabular", loaded = "opt"})
-- tabular needs to be sourced before vim-markdown
-- according to the repository site

-- TODO make optional
plug.add("plasticboy/vim-markdown")
-- This is for plasticboy/vim-markdown
-- Don't require .md extension
vim.g.vim_markdown_no_extensions_in_markdown = 1

-- Autosave when following links
vim.g.vim_markdown_autowrite = 1

require("config.plugin.vim-sneak").setup()

plug.add({
  url = "takac/vim-hardtime",
  post_handler = function()
    --api.nvim_command("let g:hardtime_default_on = 1")
  end
})

-- plug.add("AndrewRadev/switch.vim")

require("config.plugin.nvim-tree").setup()
require("config.plugin.telescope").setup()

-- TODO make optional, see init.vim so loads if python3
plug.add({
  url = "SirVer/ultisnips",
  post_handler = function()
    require("config.plugin.ultisnips")
  end
})

-- plug.add("fatih/vim-go")

  --plug.add({
  --url = "ludovicchabant/vim-gutentags",
  --post_handler = function()
  --  require("config.plugin.gutentags")
  --end
  --})

plug.add({
  url = "christoomey/vim-tmux-navigator",
  post_handler = function()
    -- TODO if config file exist on path then load automatically?
    -- flag to disable
    require("config.plugin.tmuxnavigator")
  end
})

  plug.add({
    url = "norcalli/nvim-colorizer.lua",
    loaded = "opt",
    post_handler = function()
      vim.api.nvim_command("packadd nvim-colorizer.lua")
      require'colorizer'.setup()
    end
  })

  require("config.plugin.gitsigns").setup()
  -- plug.add("udalov/kotlin-vim")
-- plug.add("machakann/vim-sandwich")
-- plug.add("PProvost/vim-ps1")

-- Auto Pairs
-- plug.add("cohama/lexima.vim")
-- TODO handle for both cases? whats the effect of disabelling in lexima
vim.g.lexima_map_escape = ""

require("config.plugin.lsp")
-- require("config.plugin.treesitter")

require("config.plugin.vim-test")
require("config.colour-overrides").setup()

plug.install()

-- Custom Plugins
-- TODO setup is in init.lua... but then all dependencies are sourced
-- so maybe init.lua just set"s up what is required to get going like autoload vs plugin directory
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
}

for i = 1, #plugins do
  require(plugins[i]).setup()
end

