return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
    cmd = "Telescope",
    keys = {
      {
        "<leader>fr",
        "<cmd>Telescope current_buffer_fuzzy_find<CR>",
        desc = "telescope find in current buffer",
      },
      {
        "<leader>fe",
        "<cmd>Telescope diagnostics<CR>",
        desc = "telescope LSP diagnostics",
      },
      {
        "<c-p>",
        function()
          local opts = require("telescope.themes").get_dropdown({
            winblend = 10,
            width = 0.8,
            prompt = " ",
            results_height = 15,
            previewer = false,
          })

          local ok = pcall(require("telescope.builtin").git_files, opts)
          if not ok then
            require("telescope.builtin").find_files(opts)
          end
        end,
        desc = "telescope open file, either git_files or fallback to CWD",
      },
      {
        "<leader>fg",
        ':lua require("telescope.builtin").live_grep()<cr>',
        desc = "telescope grep project/CWD",
      },
      {
        "<leader><space>",
        ':lua require("telescope.builtin").buffers()<cr>',
        desc = "telescope switch to an open buffer",
      },
      {
        "<leader>fs",
        '<cmd>Telescope lsp_workspace_symbols<cr>',
        desc = "telescope LSP symbols",
      },
    },
    config = function()
      local actions = require("telescope.actions")
      -- local trouble = require("trouble.sources.telescope")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<c-j>"] = actions.move_selection_next,
              ["<c-k>"] = actions.move_selection_previous,
              -- ["<c-q>"] = trouble.open,
            },
            -- n = { ["<c-q>"] = trouble.open },
          },
        },
      })
    end,
    dependencies = {
      -- adds github pull integration into telescope
      {
        "nvim-telescope/telescope-github.nvim",
        config = function()
          require("telescope").load_extension("gh")
        end,
      },
      -- this is to lazy load my extensions
      {
        dir = "telescope/_extensions",
        config = function()
          require("telescope").load_extension("bashrc")
          require("telescope").load_extension("go_src")
          require("telescope").load_extension("plugin_files")
        end,
      },
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "axkirillov/easypick.nvim",
    cmd = "Easypick",
    config = function()
      local easypick = require("easypick")
      easypick.setup({
        pickers = {
          -- diff current branch with base_branch and show files that changed with respective diffs in preview
          {
            name = "changed_files",
            command = "git diff --name-only",
            previewer = easypick.previewers.branch_diff(),
          },

          -- list files that have conflicts with diffs in preview
          {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff(),
          },
        },
      })
    end,
  },
}
