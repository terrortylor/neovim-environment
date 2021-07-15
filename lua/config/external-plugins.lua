-- Download and load my plugin manager if not on the path
local install_path = vim.api.nvim_call_function("stdpath", {"data"}) .. "/site/pack/myplugins/start/nvim-pluginman"
local fs = require("util.filesystem")
if not fs.is_directory(install_path) then
  vim.cmd("!git clone https://github.com/terrortylor/nvim-pluginman " .. install_path)
  vim.cmd("packadd nvim-pluginman")
end
local plug = require("pluginman")
plug.setup()

-- colour shceme
plug.add({
  url = "jacoborus/tender.vim",
  post_handler = function()
    vim.cmd("colorscheme tender")
  end
})

-- comment toggler
plug.add({
  url = "terrortylor/nvim-comment",
  package = "myplugins",
  -- TODO make opt and main defaults
  branch = "main",
  post_handler = function()
    require('nvim_comment').setup({
      comment_empty = false
    })
  end
})

-- http client
plug.add({
  url = "terrortylor/nvim-httpclient",
  package = "myplugins",
  -- TODO make opt and main defaults
  branch = "main",
  post_handler = function()
    require('nvim-httpclient').setup()
  end
})


-- plugins for testing neovim
-- Used for testing, has luasert embeded and doesn't require luarocks
-- TODO these should only be loaded if file ends in _spec.lua
-- but requires getting running `PlenaryBustedDirectory` working first with minimal `.vim` file
plug.add("nvim-lua/plenary.nvim")

-- Uses conceal to get terminal colours, used by plenary.nvim
plug.add({
  url = "norcalli/nvim-terminal.lua",
  post_handler = function()
    require'terminal'.setup()
  end
})

-- plug.add({url = "godlygeek/tabular", loaded = "opt"})
-- tabular needs to be sourced before vim-markdown
-- according to the repository site

vim.g.markdown_fenced_languages = {"bash=sh", "sh", "ruby"}

plug.add("plasticboy/vim-markdown")
-- This is for plasticboy/vim-markdown
-- Don't require .md extension
vim.g.vim_markdown_no_extensions_in_markdown = 1

-- Autosave when following links
vim.g.vim_markdown_autowrite = 1
-- require("config.plugins.vim-markdown")

-- quick navigation around buffer
require("config.plugins.hop").setup()

-- trying to break some bad habbits
-- require("config.plugins.vim-hardtime").setup()

-- plug.add("AndrewRadev/switch.vim")

require("config.plugins.nvim-tree").setup()
require("config.plugins.telescope").setup()

-- TODO make optional, see init.vim so loads if python3
plug.add({
  url = "SirVer/ultisnips",
  post_handler = function()
    require("config.plugins.ultisnips")
  end
})

-- plug.add("fatih/vim-go")

  --plug.add({
  --url = "ludovicchabant/vim-gutentags",
  --post_handler = function()
  --  require("config.plugins.gutentags")
  --end
  --})

-- tmux/vim seamless window/pane navigation
require("config.plugins.tmuxnavigator")

-- add syntax colour to colours and colour codes in buffers
require("config.plugins.nvim-colorizer")

-- add git line status to signs column
require("config.plugins.gitsigns").setup()

-- plug.add("machakann/vim-sandwich")

-- Auto Pairs
-- plug.add("cohama/lexima.vim")
-- TODO handle for both cases? whats the effect of disabelling in lexima
-- vim.g.lexima_map_escape = ""

-- LSP Configurations and setup entry point
require("config.plugins.nvim-lspconfig")

-- Completion
require("config.plugins.nvim-compe")
require("config.plugins.nvim-lightbulb")

require("config.plugins.treesitter")

-- run tests in a project at various levels
require("config.plugins.vim-test")

-- setup custom colour overrides
require("config.colour-overrides").setup()

plug.install()

