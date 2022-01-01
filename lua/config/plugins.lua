return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim', config = function()
    require('util.config').create_autogroups({
      cursor_line_group = {
        {
          "BufEnter",
          "lua/config/plugins.lua",
          -- luacheck: ignore
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
      config = function() require('plugins.hop') end
    },
    {
      "kyazdani42/nvim-tree.lua",
      config = function() require("plugins.nvim-tree").setup() end
    },
    {
      "takac/vim-hardtime",
      config = function()
        vim.g.hardtime_default_on = 1
        vim.g.hardtime_showmsg = 1
        vim.g.hardtime_maxcount = 3
        vim.g.hardtime_ignore_quickfix = 1
        vim.g.hardtime_allow_different_key = 1
        vim.g.hardtime_ignore_buffer_patterns = {"org", "markdown"}
        vim.g.list_of_normal_keys = {"h", "j", "k", "l", "-", "+", "<LEFT>", "<RIGHT>"}
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

  -- use {
  --   "kristijanhusak/orgmode.nvim",
  --   config = function() require("plugins.orgmode") end
  -- }

  use {
    "nvim-neorg/neorg",
    ft = "norg",
    config = function()
      require('neorg').setup {
        -- Tell Neorg what modules to load
        load = {
          ["core.defaults"] = {}, -- Load all the default modules
          ["core.keybinds"] = { -- Configure core.keybinds
              config = {
                  default_keybinds = true, -- Generate the default keybinds
                  neorg_leader = "<Leader>o" -- This is the default if unspecified
              }
          },
          ["core.norg.concealer"] = {
            config = {
              icons = {
                todo = {
                  undone = { icon = " " },
                  pending = { icon = "*" },
                  done = { icon = "x" },
                },
              },
            },
          }, -- Allows for use of icons
          ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
              workspaces = {
                my_workspace = "~/personnal-workspace/notes"
              }
            }
          },
          ["core.norg.completion"] = {
            config = {
              engine = "nvim-cmp"
            }
          }
        },
      }
      local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

      parser_configs.norg = {
          install_info = {
              url = "https://github.com/nvim-neorg/tree-sitter-norg",
              files = { "src/parser.c", "src/scanner.cc" },
              branch = "main"
          },
      }
    end,
    requires = "nvim-lua/plenary.nvim"
}

  -- general
  use {
    "blackCauldron7/surround.nvim",
    config = function()
      require"surround".setup {
        mappings_style = "surround",
        pairs = {
          nestable = {{"(", ")"}, {"[", "]"}, {"{", "}"}},
          linear = {
            {"<", ">"}, {"'", "'"}, {'"', '"'}, {'*', '*'}, {'/', '/'},
            {'-', '-'}, {'_', '_'}, {'|', '|'}, {'^', '^'}, {',',','}, {'$','$'},
            {'=','='}, {'+', '+'}
          }
        },
      }
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
    -- ft = {'go', 'sql'},
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
      -- TODO only needed on specific filetypes
      config  = function()
        require'nvim-lightbulb'.update_lightbulb {}

        require('util.config').create_autogroups({
          update_lightbulb = {
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
      { 'andersevenrud/compe-tmux', branch = 'cmp' },
      "f3fora/cmp-spell"
    }
  }

  -- autopairs
  use {
    "windwp/nvim-autopairs",
    config = function()
      require('nvim-autopairs').setup{
        disable_filetype = { "TelescopePrompt" , "vim" },
      }

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
    end,
    requires = {"hrsh7th/nvim-cmp"},
  }

  use {
    "ThePrimeagen/refactoring.nvim",
    config = function() require("plugins.refactor").setup() end,
    requires = {
      {"nvim-lua/plenary.nvim"},
      {"nvim-treesitter/nvim-treesitter"}
    }
  }

  -- Language Specific
  -- GO
  use {
    "ray-x/go.nvim",
    requires = { "nvim-telescope/telescope.nvim", },
    ft = {'go'},
    config = function() require("plugins.go-nvim").setup() end,
  }

  -- Terraform
  use {
    "hashivim/vim-terraform",
    ft = {'terraform'},
  }

  -- testing
  use {
    "vim-test/vim-test",
    ft = {"javascript", "typescript", "go"},
    config = function() require("plugins.vim-test").setup() end,
  }

end)
