return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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
        ':lua require("plugins.telescope").project_files()<cr>',
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
        "<leader>fh",
        ':lua require("telescope.builtin").help_tags()<cr>',
        desc = "telescope search tags",
      },
      {
        "<leader>ft",
        ':lua require("plugins.telescope").todo_picker()<cr>',
        desc = "telescope search todo's in CWD",
      },
      {
        "<leader>fs",
        ':lua require("telescope.builtin.lsp").dynamic_workspace_symbols()<cr>',
        desc = "telescope LSP symbols",
      },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close, -- TODO this isn't working
              ["<c-j>"] = actions.move_selection_next,
              ["<c-k>"] = actions.move_selection_previous,
            },
          },
          extensions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown({}),
            },
          },
        },
      })
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("gh")

      -- my extensions
      require("telescope").load_extension("mapdesc")
      require("telescope").load_extension("bashrc")
      require("telescope").load_extension("go_src")
      require("telescope").load_extension("awesome_src")
      require("telescope").load_extension("plugin_files")
      require("telescope").load_extension("notes")
    end,
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      -- adds github pull integration into telescope
      "nvim-telescope/telescope-github.nvim",
      "nvim-lua/plenary.nvim",
    },
  },
}
