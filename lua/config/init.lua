local api = vim.api
local has_nvim5 = api.nvim_call_function("has", {"nvim-0.5.0"})

-- If error later in scripts then this may/may not be set,
-- this is a crued way to guard around that
api.nvim_buf_set_option(0, "undofile", true)

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

plug.add({
  url = "terrortylor/nvim-comment",
  package = "myplugins",
  -- TODO make opt and main defaults
  branch = "main",
  post_handler = function()
    require('nvim_comment').setup()
  end
})

-- Used for testing, has luasert embeded and doesn't require luarocks
-- TODO these should only be loaded if file ends in _spec.lua
-- but requires getting running `PlenaryBustedDirectory` working first with minimal `.vim` file
plug.add("nvim-lua/plenary.nvim")
-- Uses conceal to get terminal colours, used by plenary.nvim
plug.add({url = "norcalli/nvim-terminal.lua", post_handler = function()
  require'terminal'.setup()
end})

-- plug.add({
--   url = "terrortylor/nvim-httpclient",
--   -- branch = "main",
--   loaded = "opt",
--   package = "myplugins",
-- })

-- Plugins
plug.add({url = "godlygeek/tabular", loaded = "opt"})
-- tabular needs to be sourced before vim-markdown
-- according to the repository site
-- TODO make optional
plug.add("plasticboy/vim-markdown")
plug.add("justinmk/vim-sneak")

plug.add({
  url = "takac/vim-hardtime",
  post_handler = function()
    --api.nvim_command("let g:hardtime_default_on = 1")
  end
})

-- TODO make optional, and have 0.5.0 checked and load alternative if so
plug.add({
  url = "preservim/nerdtree",
  post_handler = function()
    require("config.plugin.nerdtree")
  end
})

plug.add("AndrewRadev/switch.vim")

if has_nvim5 == 1 then
  -- TODO update plugin man to have depedencies so not loaded until they are
  plug.add("nvim-lua/popup.nvim")
  plug.add("nvim-lua/plenary.nvim")

  -- Requires:
  -- * nvim-lua/popup.nvim
  -- * nvim-lua/plenary.vim
  plug.add({
    url = "nvim-telescope/telescope.nvim",
    post_handler = function()
      require("config.plugin.telescope")
    end
  })

  -- adds github pull integration into telescope
  -- Requires:
  -- * nvim-telescope/telescope.nvim
  plug.add('nvim-telescope/telescope-github.nvim')
else
  plug.add({
  url = "junegunn/fzf.vim",
  post_handler = function()
    require("config.plugin.fzf")
  end
  })
end

-- TODO make optional, see init.vim so loads if python3
plug.add({
  url = "SirVer/ultisnips",
  post_handler = function()
    require("config.plugin.ultisnips")
  end
})

plug.add("fatih/vim-go")

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

-- if has_nvim5 == 1 then
  plug.add({
    url = "norcalli/nvim-colorizer.lua",
    loaded = "opt",
    post_handler = function()
      vim.api.nvim_command("packadd nvim-colorizer.lua")
      require'colorizer'.setup()
    end
  })

  plug.add("tjdevries/colorbuddy.nvim")

  -- plug.add({
  --   url = "terrortylor/nvim-tender",
  --   package = "myplugins",
  --   post_handler = function()
  --     -- require('nvim-tender')
  --    -- vim.api.nvim_command("colorscheme nvim-tender")
  --   end
  -- })

-- else
  plug.add({
    url = "jacoborus/tender.vim",
    post_handler = function()
      vim.api.nvim_command("colorscheme tender")
    end
  })
-- end

plug.add({
  url = "lewis6991/gitsigns.nvim",
  branch = "main",
  post_handler = function()
    require('gitsigns').setup {
      signs = {
        add          = {hl = 'GitGutterAdd'   , text = '+', numhl='GitGuttersAddNr'},
        change       = {hl = 'GitGutterChange', text = '~', numhl='GitGuttersChangeNr'},
        delete       = {hl = 'GitGutterDelete', text = '_', numhl='GitGuttersDeleteNr'},
        topdelete    = {hl = 'GitGutterDelete', text = '‾', numhl='GitGuttersDeleteNr'},
        changedelete = {hl = 'GitGutterChange', text = '~', numhl='GitGuttersChangeNr'},
      },
      numhl = false,
      keymaps = {
        -- Default keymap options
        noremap = true,
        buffer = true,

        ['n ]h'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
        ['n [h'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

        ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',

        -- Text objects
        ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
        ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
      },
      watch_index = {
        interval = 1000
      },
      sign_priority = 6,
      status_formatter = nil, -- Use default
    }
  end
})

-- plug.add("udalov/kotlin-vim")
-- plug.add("machakann/vim-sandwich")
-- plug.add("PProvost/vim-ps1")

if has_nvim5 == 1 then
  plug.add({ url = "neovim/nvim-lspconfig",
    post_handler = function()
      require("config.lsp")
    end
  })

  plug.add({ url = "hrsh7th/nvim-compe",
    post_handler = function()
      require("config.plugin.nvim_compe")
    end
  })

  plug.add({ url = "kosayoda/nvim-lightbulb",
  post_handler  = function()
    require'nvim-lightbulb'.update_lightbulb {}
    vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    vim.api.nvim_set_option("updatetime", 500)
    end
  })
end

plug.install()

-- Custom Plugins
-- TODO setup is in init.lua... but then all dependencies are sourced
-- so maybe init.lua just set"s up what is required to get going like autoload vs plugin directory
local plugins = {
  "git",
  "ui.arglist",
  "tmux",
  "alternate",
  "pa",
  "snake",
  "wiki",
  --"fzf",
  "test"
}

for i =1, #plugins do
  require(plugins[i]).setup()
end

