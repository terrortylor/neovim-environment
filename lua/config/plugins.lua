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
plug.add({
  url = "ray-x/go.nvim",
  post_handler = function ()
    -- Import on save
    require('util.config').create_autogroups({
      go_format_imports_on_save = {
        {"BufWritePre", "*", ":silent! lua require('go.format').goimport()"}
      },
    })

    require 'go'.setup({
      goimport = 'gopls',
    })
  end
})

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
-- vim.g.lexima_map_escape = ""

-- LSP Configurations and setup entry point
require("plugins.nvim-lspconfig")

-- Completion
require("plugins.nvim-compe")
require("plugins.nvim-lightbulb")
-- signature help
plug.add("ray-x/lsp_signature.nvim")

require("plugins.treesitter")

-- run tests in a project at various levels
-- require("plugins.vim-test")

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
  "generator",
  "pa",
  "test-runner",
  "snake",
  "wiki",
  "util.auto_update",
}

for i,p in pairs(plugins) do
  require(p).setup()
end
