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
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        -- theme = "tokyonight",
        globalstatus = true,
      },
      tabline = {
        lualine_a = { "tabs" },
        lualine_z = { "diagnostics" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {},
        -- lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      winbar = {
        lualine_a = { "filename" },
      },
      inactive_winbar = {
        lualine_a = { "filename" },
      },
    },
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
    opts = { rename_files = false },
    keys = {
      { "<leader>h", ':lua require("replacer").run()<cr>', desc = "quickfix: run replacer.nvim" },
      { "<leader>H", ':lua require("replacer").save()<cr>', desc = "quickfix: save replacer.nvim" },
    },
  },

  {
    -- make search replace varients better
    "tpope/vim-abolish",
    cmd = { "Subvert", "S" },
    keys = {
      { "cr", "<Plug>(abolish-coerce-word)", noremap = true, silent = true },
    },
    config = function()
      require("which-key").register({
        cr = {
          name = "+coercion",
          c = { desc = "camelCase" },
          m = { desc = "MixedCase" },
          _ = { desc = "snake_case" },
          s = { desc = "snake_case" },
          u = { desc = "UPPER_CASE" },
          U = { desc = "UPPER_CASE" },
          k = { desc = "dash-case" },
          ["-"] = { desc = "dash-case (not reversible)" },
          ["."] = { desc = "dot.case (not reversible)" },
          ["<space>"] = { desc = "Space Case (not reversible)" },
        },
      })
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    -- lazy = false,
    keys = {
      {
        "<leader>rr",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
      { "<leader>rp", ":lua require('refactoring').debug.printf()<CR>" },
      -- Print var: this remap should be made in visual mode
      -- { "<leader>rpv", ":lua require('refactoring').debug.print_var({})<CR>", node = "v" },

      -- Cleanup function: this remap should be made in normal mode
      { "<leader>rcp", ":lua require('refactoring').debug.cleanup({})<CR>" },
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
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<c-n>",
        function()
          require("nvim-tree.api").tree.open({ find_file = true })
        end,
        desc = "Togggle File Tree",
      },
    },
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "<CR>", api.node.open.no_window_picker, opts("Expand All"))
      end

      -- open file after creating
      local Event = require("nvim-tree.api").events.Event
      local api = require("nvim-tree.api")
      api.events.subscribe(Event.FileCreated, function(data)
        require("nvim-tree.view").close()
        vim.cmd(":edit " .. data.fname)
      end)

      require("nvim-tree").setup({
        on_attach = on_attach,
        select_prompts = true,
        git = {
          ignore = false,
        },
        update_focused_file = {
          enable = true,
        },
        view = {
          adaptive_size = {},
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        actions = {
          open_file = {
            quit_on_open = true,
            window_picker = {
              enable = false,
            },
          },
        },
      })
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
        require("hover.providers.dictionary")
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
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        mapping = { "jj" },
      })
    end,
  },

  {
    "folke/trouble.nvim",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "[c",
        function()
          require("trouble").previous({ skip_groups = true, jump = true })
        end,
        desc = "Trouble list previous item",
      },
      {
        "]c",
        function()
          require("trouble").next({ skip_groups = true, jump = true })
        end,
        desc = "Trouble list next item",
      },
    },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
  },

  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },

        routes = {
          { -- ignore buf written messages
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        },

        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end,
  },
}
