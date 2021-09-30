return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim', config = function()
    require('util.config').create_autogroups({
      cursor_line_group = {
        {
          "BufEnter",
          "lua/config/plugins.lua",
          "lua vim.api.nvim_buf_set_keymap(0, 'n', '<leader>nn', '<cmd>luafile %<cr> | <cmd>PackerCompile<cr> | <cmd>PackerSync<cr>', {})"
        },
      },
    })
  end}

  -- colour scheme
  -- Setting the colourscheme here prevents the info screen showing when opened without a file
  use { "terrortylor/zephyr-nvim", config = function() vim.cmd("colorscheme zephyr") end }

  -- toggle comments
  use {
    "terrortylor/nvim-comment",
    config = function()
      require('nvim_comment').setup({
        comment_empty = false
      })
    end
  }

  -- navigation
  use {
    {
      -- tmux/vim magic!
      "christoomey/vim-tmux-navigator",
      config = function()
        -- vim.g.tmux_navigator_no_mappings = 1
        vim.g.tmux_navigator_disable_when_zoomed = 1
        vim.g.tmux_navigator_save_on_switch = 2

      end
    },
    -- quickly jump to locations in the visible buffer
    {
      "phaazon/hop.nvim",
      config = function()
        require'hop'.setup {
          keys = 'etovxqpdygfblzhckisuran',
        }

        vim.api.nvim_set_keymap("n", "<leader>fj", ":HopWord<CR>", {noremap = true, silent = true})
      end
    },
    {
      "kyazdani42/nvim-tree.lua",
      config = function() require("plugins.nvim-tree").setup() end
    },
    {
      "takac/vim-hardtime",
      config = function()
        vim.g.hardtime_default_on = 1
        vim.g.hardtime_allow_different_key = 1
      end
    }
  }

  -- neovim general library, dependancy for many plugins, also a neovim lua test runner :)
  -- nvim-terminal provides colour code conceal for nicer output
  use {
    "nvim-lua/plenary.nvim",
    requires = {"norcalli/nvim-terminal.lua"},
    config = function() require("terminal").setup() end
  }

  -- general
  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require"surround".setup {mappings_style = "surround"}
    end
  }

  -- telescope
  use {
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim"
      },
      config = function() require("plugins.telescope").setup() end
    },
    {
      -- adds github pull integration into telescope
      "nvim-telescope/telescope-github.nvim",
      requires = { "nvim-telescope/telescope.nvim" },
    }
  }

  -- treesitter
  use {
    {
      "nvim-treesitter/nvim-treesitter",
      run = ':TSUpdate',
      config = function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = {"javascript", "typescript", "lua", "go"},
          highlight = {
            enable = true,
          },
          query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = {"BufWrite", "CursorHold"},
          },
        }
      end
    },
    {
      "nvim-treesitter/playground",
      opt = true,
      cmd = {"TSPlaygroundToggle"},
      requires = { "nvim-treesitter/nvim-treesitter", }
    }
  }

  use {
    "L3MON4D3/LuaSnip",
    config = function() require('plugins.luasnip').setup() end,
    ft = {'go', 'sql'},
  }

  -- add some colour to colors and colour codes in buffers
  use {
    "norcalli/nvim-colorizer.lua",
    opt = true,
    cmd = {"ColorizerAttachToBuffer", "ColorizerDetachFromBuffer",
    "ColorizerReloadAllBuffers", "ColorizerToggle"},
    config = function() require'colorizer'.setup() end
  }

  -- visual sugar
  use {
    -- git signs
    {
      "lewis6991/gitsigns.nvim",
      config = function() require("plugins.gitsigns").setup() end,
    },
    -- show lightbulb when code action
    {
      "kosayoda/nvim-lightbulb",
      config  = function()
        require'nvim-lightbulb'.update_lightbulb {}

        require('util.config').create_autogroups({
          return_to_last_edit_in_buffer = {
            {"CursorHold,CursorHoldI", "*", "lua require'nvim-lightbulb'.update_lightbulb()"}
          }})

        vim.api.nvim_set_option("updatetime", 500)
      end
    },
  }

  -- language server
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.lsp.sumneko")
      require("plugins.lsp.tsserver")
      -- not required when using ray-s/go.nvim
      require("plugins.lsp.gopls")
      require("plugins.lsp.bashls")
      require("plugins.lsp.efm")
    end
  }

  -- completion
  use {
    "hrsh7th/nvim-cmp",
    config = function() require("plugins.nvim-cmp").setup() end,
    requires = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      { 'andersevenrud/compe-tmux', branch = 'cmp' }
    }
  }

  use {
    "ThePrimeagen/refactoring.nvim",
    config = function() require("plugins.refactor").setup() end,
    requires = {
      {"nvim-lua/plenary.nvim"},
      {"nvim-treesitter/nvim-treesitter"}
    }
  }

  -- GO
  use {
    "ray-x/go.nvim",
    requires = { "nvim-telescope/telescope.nvim", },
    ft = {'go'},
    config = function() require("plugins.go-nvim").setup() end,
  }

  -- testing
  use {
    "vim-test/vim-test",
    ft = {"javascript", "typescript", "go"},
    config = function() require("plugins.vim-test").setup() end,
  }

end)
