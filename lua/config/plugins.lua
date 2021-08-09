return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- colour scheme
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
      config = [[require("plugins.nvim-tree").setup()]]
    }
  }

  -- neovim general library, dependancy for many plugins, also a neovim lua test runner :)
  -- nvim-terminal provides colour code conceal for nicer output
  use { "nvim-lua/plenary.nvim", requires = {"norcalli/nvim-terminal.lua"}, config = function()
    require("terminal").setup()
  end}

  -- telescope
  use {
    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim"
      },
      config = [[require("plugins.telescope").setup()]]
    },
    {
      -- adds github pull integration into telescope
      "nvim-telescope/telescope-github.nvim",
      requires = {
        "nvim-telescope/telescope.nvim"
      },
    }
  }

  -- treesitter
  use {
    {
      "nvim-treesitter/nvim-treesitter",
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
      requires = {
        "nvim-treesitter/nvim-treesitter",
      }
    }
  }

  -- snipets
  use {
    "SirVer/ultisnips",
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsEditSplit = "vertical"
      -- TODO c-u isn't a great mapping as overrides builtin
      vim.g.UltiSnipsListSnippets = "<c-u>"
      vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
      vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
    end
  }

  -- add some colour to colors and colour codes in buffers
  use {
    "norcalli/nvim-colorizer.lua",
    opt = true,
    cmd = {"ColorizerAttachToBuffer", "ColorizerDetachFromBuffer",
    "ColorizerReloadAllBuffers", "ColorizerToggle"},
    config = function()
      require'colorizer'.setup()
    end
  }

  -- visual sugar
  use {
    -- git signs
    {
      "lewis6991/gitsigns.nvim",
      config = [[require("plugins.gitsigns").setup()]],
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
    -- function signiture help in insert mode
    {
      "ray-x/lsp_signature.nvim"
    }
  }

  -- language server
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.lsp.sumneko")
      require("plugins.lsp.tsserver")
      require("plugins.lsp.gopls")
      require("plugins.lsp.bashls")
      require("plugins.lsp.efm")
    end
  }

  -- completion
  use {
    "hrsh7th/nvim-compe",
    config = [[require("plugins.nvim-compe").setup()]],
  }

end)

-- -- http client
-- plug.add({
--   url = "terrortylor/nvim-httpclient",
--   package = "myplugins",
--   -- TODO make opt and main defaults
--   branch = "main",
--   post_handler = function()
--     require('nvim-httpclient').setup()
--   end
-- })


-- -- plug.add({url = "godlygeek/tabular", loaded = "opt"})
-- -- tabular needs to be sourced before vim-markdown
-- -- according to the repository site

-- vim.g.markdown_fenced_languages = {"bash=sh", "sh", "ruby"}

-- plug.add("plasticboy/vim-markdown")
-- -- This is for plasticboy/vim-markdown
-- -- Don't require .md extension
-- vim.g.vim_markdown_no_extensions_in_markdown = 1

-- -- Autosave when following links
-- vim.g.vim_markdown_autowrite = 1
-- -- require("plugins.vim-markdown")

-- -- trying to break some bad habbits
-- -- require("plugins.vim-hardtime").setup()

-- -- plug.add("AndrewRadev/switch.vim")

-- -- plug.add("fatih/vim-go")
-- plug.add({
--   url = "ray-x/go.nvim",
--   post_handler = function ()
--     -- Import on save
--     require('util.config').create_autogroups({
--       go_format_imports_on_save = {
--         {"BufWritePre", "*", ":silent! lua require('go.format').goimport()"}
--       },
--     })

--     require('go').setup({
--       goimport = 'gopls',
--     })
--   end
-- })

-- -- plug.add("machakann/vim-sandwich")

-- -- run tests in a project at various levels
-- -- require("plugins.vim-test")

-- -- setup custom colour overrides
-- require("config.colour-overrides").setup()
