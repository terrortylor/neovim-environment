return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      -- component_separators = { left = '|', right = '|'},
      -- section_separators = { left = '|', right = '|'},
      theme = "tokyonight",
    },
  },

  -- toggle comments
  {
    "terrortylor/nvim-comment",
    -- "~/personal-workspace/nvim-plugins/nvim-comment",
    config = function()
      require("nvim_comment").setup({
        comment_empty = false,
      })
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({})
    end,
  },

  {
    "gabrielpoca/replacer.nvim",
    keys = {
      { "<leader>h", ':lua require("replacer").run()<cr>' },
    },
  },

  {
    -- make search replace varients better
    "tpope/vim-abolish",
    cmd = { "Subvert", "S" },
    config = function()
      vim.g.abolish_no_mappings = true
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>rr",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        npremap = true,
        sipent = true,
        expr = false,
      },
      { "<leader>rp", ":lua require('refactoring').debug.printf({below = false})<CR>" },
      -- Print var: this remap should be made in visual mode
      { "<leader>rpv", ":lua require('refactoring').debug.print_var({})<CR>", node = "v" },

      -- Cleanup function: this remap should be made in normal mode
      { "<leader>rpc", ":lua require('refactoring').debug.cleanup({})<CR>" },
    },
    opts = {
      -- prompt for return type
      prompt_func_return_type = {
        go = true,
        java = true,
      },
      -- prompt for function parameters
      prompt_func_param_type = {
        go = true,
        java = true,
      },
    },
  },

  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      { "<c-n>", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Togggle File Tree" },
    },
    config = function()
      require("nvim-tree").setup({
        actions = {
          open_file = {
            quit_on_open = true,
            window_picker = {
              -- TODO reenable if ever vsplit_no_picker option exists
              enable = false,
              -- chars = "asdfjkl;",
            },
          },
        },
        view = {
          mappings = {
            list = {
              { key = { "o" }, action = "edit", mode = "n" },
              { key = { "<CR>", "<2-LeftMouse>" }, action = "edit_no_picker", mode = "n" },
            },
          },
        },
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              git = false,
              folder_arrow = false,
              file = false,
            },
            glyphs = {
              default = " ",
              folder = {
                default = "ᐅ",
                open = "ᐁ",
                empty = "ᐅ",
                empty_open = "ᐅ",
                symlink = "ᐅ",
              },
              git = {
                unstaged = "~",
                staged = "✓",
                unmerged = "M",
                renamed = "R",
                untracked = "★",
                deleted = "✗",
                ignored = "🙅",
              },
            },
          },
        },
        diagnostics = {
          enable = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "E",
          },
        },
        git = {
          ignore = false,
        },
      })
      -- open file after creating
      local Event = require("nvim-tree.api").events.Event
      local api = require("nvim-tree.api")
      api.events.subscribe(Event.FileCreated, function(data)
        require("nvim-tree.view").close()
        vim.cmd(":edit " .. data.fname)
      end)
    end,
  },

  {
    "eandrju/cellular-automaton.nvim",
    keys = {
      { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
    },
  },

  {
    "lewis6991/hover.nvim",
    keys = {
      { "KK", ':lua require("hover").hover()<cr>', desc = "hover.nvim" },
      { "gKK", ':lua require("hover").hover_select()<cr>', desc = "hover.nvim (select)" },
    },
    opts = {
      init = function()
        -- Require providers
        require("hover.providers.lsp")
        -- require('hover.providers.gh')
        -- require('hover.providers.gh_user')
        -- require('hover.providers.jira')
        -- require('hover.providers.man')
        require('hover.providers.dictionary')
      end,
      preview_opts = {
        border = nil,
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
    },
  },
}
