return {

  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({})
    end,
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

}
